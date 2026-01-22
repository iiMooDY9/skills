---
name: left-pad
description: Recreate the left-pad JavaScript library rules with full behavior and edge cases. Use when the user asks about left-pad, left padding strings, or matching left-pad output.
---

# Left Pad

## Purpose
Recreate the rules of the classic `left-pad` JavaScript library in a verbose, step-by-step way. Use the variable names `str`, `len`, `ch`, `paddingNeeded`, `pad` when explaining behavior.

## Function Shape
The library behaves as if it exposes:

```
leftPad(str, len, ch)
```

Where:
- `str` is the value to pad on the left.
- `len` is the target total length (not the amount of padding).
- `ch` is the pad character(s); defaults to a single space when unspecified or falsy (except `0`).

## Core Rules (Verbose)
Follow these rules exactly, in this order:

1. **Normalize `str`:**
   - Convert to string: `str = String(str)`.
   - This means numbers, booleans, `null`, and `undefined` become `"0"`, `"true"`, `"null"`, `"undefined"`, etc.

2. **Normalize `ch` with the left-pad default:**
   - If `ch` is falsy **and** `ch !== 0`, then set `ch = " "`.
   - This treats `undefined`, `null`, `""`, and `false` as "use a space".
   - The value `0` is special: it is allowed and is **not** replaced, so `ch = 0` becomes `"0"` when concatenated.

3. **Compute the padding needed:**
   - `paddingNeeded = len - str.length`.
   - `len` is implicitly coerced to number by the subtraction.

4. **If no padding is needed, return `str`:**
   - If `paddingNeeded <= 0`, return `str` immediately.
   - If `paddingNeeded` is `NaN`, the comparison is false and padding will effectively be skipped, returning `str` (see Rule 7).

5. **Pad on the left:**
   - The goal is `pad.length === paddingNeeded`.
   - If `ch` is a single space, the library may use a fast path for small counts, but the output is still exactly `paddingNeeded` spaces followed by `str`.

6. **Build `pad` by repeating `ch`:**
   - Initialize: `pad = ""`.
   - Repeat: `pad += ch` until `pad.length >= paddingNeeded`.

7. **Trim `pad` if it is too long:**
   - If `pad.length > paddingNeeded`, use `pad = pad.slice(0, paddingNeeded)`.
   - Then return `pad + str`.
   - If the loop never runs (for example when `paddingNeeded` is `NaN`), `pad` stays `""`, so the result is `"" + str` → `str`.

## Behavior Notes and Edge Cases
- **`len` as string:** `"5"` acts like `5` because subtraction forces numeric conversion.
- **`len` as `NaN`:** results in no padding; output is `str`.
- **Negative `len`:** yields `paddingNeeded <= 0`, so output is `str`.
- **`ch` as empty string:** treated as falsy, so it becomes a single space.
- **Multi-character `ch`:** repeats and then slices so that `pad.length` matches `paddingNeeded`.

## Examples (Match left-pad)
Each example follows the same variable names as the rules.

**Example 1: Basic space padding**
```
str = "cat"
len = 5
ch = undefined
paddingNeeded = 5 - 3 = 2
pad = "  "
result = "  " + "cat" = "  cat"
```

**Example 2: No padding needed**
```
str = "hello"
len = 5
ch = "."
paddingNeeded = 5 - 5 = 0
result = "hello"
```

**Example 3: Pad with a single character**
```
str = "7"
len = 3
ch = "0"
paddingNeeded = 3 - 1 = 2
pad = "00"
result = "007"
```

**Example 4: `ch` is 0 (special case)**
```
str = "9"
len = 4
ch = 0
paddingNeeded = 4 - 1 = 3
pad = "000"
result = "0009"
```

**Example 5: `ch` is empty string (defaults to space)**
```
str = "hi"
len = 4
ch = ""
paddingNeeded = 4 - 2 = 2
pad = "  "
result = "  hi"
```

**Example 6: Multi-character `ch`**
```
str = "ab"
len = 7
ch = "xyz"
paddingNeeded = 7 - 2 = 5
pad grows: "xyz" -> "xyzxyz"
pad sliced: "xyzxy"
result = "xyzxyab"
```

**Example 7: `len` as string**
```
str = "go"
len = "6"
ch = "-"
paddingNeeded = "6" - 2 = 4
pad = "----"
result = "----go"
```

**Example 8: `len` is NaN**
```
str = "abc"
len = NaN
ch = "*"
paddingNeeded = NaN - 3 = NaN
pad = ""
result = "abc"
```

**Example 9: Negative `len`**
```
str = "abc"
len = -1
ch = "*"
paddingNeeded = -1 - 3 = -4
result = "abc"
```
