# Trap House

Where the RawrXD IDE strangeness goes.

```ini
REPOSITORY_ROLE=CURATED_RECOVERY
SOURCE_OF_TRUTH=0
BUILD_AUTHORITY=0
HISTORICAL_SALVAGE=1
CANONICAL_CODE=NO
COMPLETE_IDE_REPOSITORY=NO
```

**Read this before drawing any conclusion from the file list.** These 15 files
are a *curated extraction*, not the IDE repository. They do not build as a
project, they are not the authoritative copy, and their presence here implies
nothing about completeness. The canonical source is
[`ItsMehRAWRXD/RawrXD`](https://github.com/ItsMehRAWRXD/RawrXD) branch
`beacon-residency-001`, where the same content is committed with full history.

The purpose is separation of concerns: IDE work should not be buried inside a
1.9 GB scrape archive, and a reader who finds it here should be told
immediately that this is a salvage drawer rather than a home.

## Why this repository exists

Three IDE-flavoured repositories already existed on this account:

| Repository | Size | Last push |
|---|---:|---|
| `RawrXD-IDE-Final` | 1.97 GB | 2026-09-08 |
| `RawrXD-IDE-Win32-Gui-CLI-HTML` | 1.98 GB | 2026-09-08 |
| `RawrXDA` | 1.87 GB | 2026-09-08 |

All three are approximately 1.9 GB, all three were last pushed on the same
day, and a shallow clone of `RawrXD-IDE-Final` yields **92,995 files** whose
top level includes `node_modules/`, `Advanced_Reverse_Engineered/`,
`Cursor_Source_Extracted/`, `.backups/`, `.cache/` and `ARCHIVE_Status3_FINAL/`.

So none of them is a maintained source repository. They are scrape archives.
Dumping C++ source into a 1.9 GB `node_modules` tree would make the code
*less* findable, not more, and would risk the clone failures already visible
locally (`error: unable to create file ... Filename too long`).

With no real IDE repository present, this one was created to hold that work
as ordinary source with ordinary history.

## What is here

IDE-layer sources from the main tree, at the paths they occupy there so they
can be diffed against `ItsMehRAWRXD/RawrXD`:

```
rawrxd/src/asm/RawrXD_HexMag_AbiProbe.asm        MASM ABI probe
rawrxd/src/asm/RawrXD_HexMag_RepeatTuner.asm     MASM repeat tuner
rawrxd/include/agent/hexmag_client.hpp           agent <-> IDE client interface
rawrxd/src/agent/hexmag_client.hpp
rawrxd/src/agent/hexmag_client.cpp
rawrxd/src/core/win32ide_debugger_bridge.cpp     debugger bridge
rawrxd/src/app/cpu_inference_engine_autofix.cpp  CPU engine autofix
rawrxd/src/app/cpu_inference_engine_autofix.hpp
rawrxd/tests/hexmag_ide_e2e_cert.cpp             IDE end-to-end cert
rawrxd/tests/hexmag_repeat_tuner_cert.cpp        repeat tuner cert
rawrxd/tests/hexmag_runtime_controller_cert.cpp  runtime controller cert
rawrxd/tools/hexmag_abi_probe.cpp                ABI probe driver
_audit_ide_full.ps1                              full IDE audit
_audit_ide_sources.ps1                           IDE source inventory
_audit_ide_report.md                             IDE audit report
```

## Status, honestly

This is a **snapshot**, not a maintained mirror. It carries no claim that
these files build, pass, or are current. Several are known-impure:

- `hexmag_ide_e2e_cert` is the subject of an open `/O2` shipping-authority
  investigation. Individual exports pass at `/O2`, but the composed
  `Init -> queue -> PollEvent xN -> Shutdown` sequence has an unresolved
  failure between the last valid pre-return state and successful caller
  continuation. `HEXMAG_SHIPPING_OPTIMIZED_AUTHORITY=OPEN`.
- `RawrXD_HexMag_RepeatTuner.asm` is mid-change.
- A contiguous-pin fix in the GPU-forward path is implemented but has
  **0 calls** and is explicitly **not load-bearing**.

The authoritative status of each file lives with its receipt, not here.

## Provenance

Extracted from `F:\~dev` (repository `ItsMehRAWRXD/RawrXD`, branch
`beacon-residency-001`) on 2026-10-04. The same content is committed in that
repository; this repository exists so the IDE work is not buried inside a
1.9 GB scrape archive.