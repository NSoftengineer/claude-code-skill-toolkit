---
name: ps-verify-issue
description: Check actual GitHub Issue acceptance criteria against code, tests and role scope without modifications.
argument-hint: "<issue-number>"
disable-model-invocation: true
---
Check real issue via read-only gh; inspect implementation and test evidence; delegate github-issue-verifier; return PASS/FAIL/BLOCKED/PARTIAL, evidence by acceptance criterion and outstanding role handoffs. Never edit issues/code.
