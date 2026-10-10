#!/usr/bin/env python3
"""Build the localized Apple Silicon app with the pinned local SDK."""
from pathlib import Path
import argparse
import os
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--sdk', default='/Library/Developer/CommandLineTools/SDKs/MacOSX26.5.sdk')
args = parser.parse_args()
base = Path(__file__).resolve().parent
source = base / 'Compositor'
build = base / 'build'
build.mkdir(exist_ok=True)
if not Path(args.sdk).is_dir():
    parser.error('SDK does not exist; provide --sdk /path/to/MacOSX26.5.sdk')
objects = []
for path in sorted(source.rglob('*.c')):
    output = build / (path.stem + '.o')
    subprocess.run(['xcrun', 'clang', '-O2', '-target', 'arm64-apple-macosx26.0',
                    '-isysroot', args.sdk, '-c', str(path), '-o', str(output)], check=True)
    objects.append(str(output))
command = ['xcrun', 'swiftc', '-sdk', args.sdk, '-target', 'arm64-apple-macosx26.0',
           '-parse-as-library', '-module-name', 'Compositor', '-O', '-whole-module-optimization',
           '-default-isolation', 'MainActor', '-enable-upcoming-feature', 'MemberImportVisibility',
           '-enable-upcoming-feature', 'NonisolatedNonsendingByDefault', '-import-objc-header',
           str(source / 'Compositor-Bridging-Header.h'), '-o', str(build / 'Compositor')]
command += [str(path) for path in sorted(source.rglob('*.swift'))] + objects
subprocess.run(command, check=True)
app = build / 'Compositor 中文版.app'
contents = app / 'Contents'
(contents / 'MacOS').mkdir(parents=True, exist_ok=True)
shutil.copy2(build / 'Compositor', contents / 'MacOS/Compositor')
shutil.copy2(base / 'Info.plist', contents / 'Info.plist')
shutil.copytree(base / 'Resources', contents / 'Resources', dirs_exist_ok=True)
os.chmod(contents / 'MacOS/Compositor', 0o755)
subprocess.run(['codesign', '--force', '--sign', '-', '--entitlements',
                str(base / 'Local.entitlements'), str(app)], check=True)
subprocess.run(['codesign', '--verify', '--strict', str(app)], check=True)
print(app)
