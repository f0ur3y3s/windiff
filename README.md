# WinDiff

A collection of tools to extract, apply reverse and/or forward deltas on Windows MSU packages.

## Files

- `delta_patch.py`
    - A python script to apply reverse and/or forward deltas
- `PatchExtract.ps1`
    - A powershell script to extract older MSU packages
- `PatchExtract-1_5.ps1`
    - An updated powershell script based on the original to extract the new Windows MSU file formats.
    - **NOTE**: This updated script was generated with Claude 3.7 by feeding the Microsoft documentation on the MSU format to the original script

## Usage

### Applying patches

```
python delta_patch.py -i <current file> -o <output file> <reverse patch[optional]> <forward patch[optional]
```

### Older MSU packages

```
Powershell -ExecutionPolicy Bypass -File PatchExtract.ps1 -Patch <msu update> -Path .\patch
```

### Newer MSU packages

```
Powershell -ExecutionPolicy Bypass -File PatchExtract-1_5.ps1 -Patch <msu update> -Path .\patch
```
