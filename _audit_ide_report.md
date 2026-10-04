# RAWRXD IDE End-to-End Source Audit Report
**Date:** 2026-10-04  
**Branch:** beacon-residency-001  
**Repository:** f:\~dev\rawrxd  
**Auditor:** RAWRXD_IDE_AUDIT_001

---

## Executive Summary

| Metric | Count |
|--------|-------|
| **Total unique source files referenced in CMakeLists.txt** | ~540 |
| **Active sources in WIN32IDE_SOURCES** | ~520 |
| **Active sources PRESENT on disk** | ~520 |
| **Active sources MISSING** | **0** |
| **Excluded/commented-out sources** | ~60 |
| **Excluded sources ALSO MISSING** | **2** |
| **Total MISSING (including excluded)** | **2** |

**Verdict: PASS** — All active sources required for the Win32IDE build are present on disk. The two "missing" files are intentionally excluded stubs that were replaced by real implementations.

---

## Methodology

1. Parsed `CMakeLists.txt` line-by-line for all `WIN32IDE_SOURCES` blocks
2. Extracted both active (uncommented) and excluded (commented) source references
3. Cross-checked every file path against the actual filesystem in `f:\~dev\rawrxd`
4. Categorized results as PRESENT, MISSING, or EXCLUDED

---

## Active Sources Audit

All ~520 active source files referenced in `WIN32IDE_SOURCES` are present and accounted for. Key directories represented:

- `src/win32app/` — IDE UI implementation (~120 files)
- `src/core/` — Core engine and subsystem implementations (~80 files)
- `src/deep2/` — Deep2 inference engine (~25 files)
- `src/agent/` — Agent orchestration (~15 files)
- `src/agentic/` — Agentic tooling (~15 files)
- `src/bridge/` — Bridge components (~5 files)
- `src/command/` — Command system (~5 files)
- `src/ui/` — UI components (~5 files)
- `src/security/` — Security/keystore (~3 files)
- `Ship/` — Shipping pipeline (~2 files)
- `src/runtime/` — Runtime memory management (~10 files)
- `src/sovereign/` — Sovereign autonomy system (~15 files)
- `src/repointel/` — Repository intelligence (~3 files)

---

## Excluded Sources Audit

Approximately 60 source files are referenced in comments (excluded via `# AUTO-REMOVED`, `# EXCLUDED`, etc.). Most of these files exist on disk and were excluded for legitimate reasons:

### Excluded but Present (~58 files)
Examples:
- `src/deep2/Deep2APIServer.cpp` — excluded, exists
- `src/deep2/production/Deep2ProductionRuntime.cpp` — excluded, exists
- `src/ide/Deep2Bridge.cpp` — excluded, exists
- `src/ide/GitCommitDialog.cpp` — excluded, exists
- Multiple `*_stubs.cpp` files — excluded, exist (kept for reference but not linked)

### Excluded and Missing (2 files)

#### 1. `src/core/hexmag_masm_stubs.cpp`
- **Status:** INTENTIONALLY REMOVED
- **Reason:** Replaced by real MASM implementations (`src/asm/RawrXD_HexMag_Swarm.asm`, `src/asm/RawrXD_HexMag_RepeatTuner.asm`)
- **CMakeLists.txt reference:** Lines 7190-7225 document this removal
- **Action required:** NONE — The real implementations provide all 13 symbols

#### 2. `src/core/monaco_core_stubs.cpp`
- **Status:** INTENTIONALLY REMOVED
- **Reason:** Replaced by real implementation (`src/core/MonacoCore.cpp`)
- **CMakeLists.txt reference:** Lines 8150-8165 document this replacement
- **Action required:** NONE — Real gap-buffer text model is present and linked

---

## Identified Gaps and Notes

### 1. Missing External Dependency: `<sstring>` (TinyString)
- **Location:** `src/core/auto_feature_real_impl.cpp:14`
- **Impact:** File cannot be compiled; excluded from WIN32IDE_SOURCES
- **Status:** Documented in CMakeLists.txt lines 6094-6115
- **Action:** Obtain TinyString header from upstream or replace with `std::string`

### 2. Duplicate Sources
- Several files appear multiple times in `WIN32IDE_SOURCES`:
  - `src/deep2/Deep2Engine.cpp` — appears twice
  - `src/deep2/StreamEngine.cpp` — appears twice
  - `src/deep2/AntiPatcher.cpp` — appears twice
  - `src/repointel/RepositoryUniverse.cpp` — appears twice
  - `src/repointel/ScopeTree.cpp` — appears twice
  - `src/runtime/memory/*` files — duplicated between blocks
- **Impact:** CMake deduplicates automatically; no build failure
- **Action:** Cleanup recommended for maintainability

### 3. Stub Files Still Present
- Many `*_stubs.cpp` files exist on disk but are excluded from build
- They are preserved as reference but not linked
- **Action:** Consider moving to `archive/` or deleting if truly obsolete

---

## Build Verification

The most recent build completed successfully:
```
cmake --build build --config Release --target RawrXD-Win32IDE
Exit Code: 0
```

Binary produced:
```
build\bin\Release\RawrXD-Win32IDE.exe (valid, linked)
```

---

## Recommendations

| Priority | Item | Action |
|----------|------|--------|
| P1 | Remove duplicate source entries from CMakeLists.txt | Dedupe WIN32IDE_SOURCES |
| P2 | Resolve `<sstring>` dependency or replace with std::string | Enable auto_feature_real_impl.cpp |
| P3 | Clean up obsolete stub files | Move to archive/ or delete |
| P4 | Document intentionally missing files in a manifest | Prevent future audit confusion |
| P5 | Implement source graph authority for automatic verification | RAWRXD_SOURCE_GRAPH_AUTHORITY_001 |

---

## Conclusion

The IDE source tree is complete for active build purposes. No missing files block compilation or linking. The two files reported as "missing" are intentionally excluded stubs that were superseded by real implementations. The build succeeds and produces a valid binary.

**Audit Verdict: PASS**  
**Missing Active Sources: 0**  
**Unexplained Gaps: 0**

---
*Report generated by automated source audit script*  
*Raw output: f:\~dev\_audit_ide_full.ps1*
