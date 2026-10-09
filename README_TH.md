# Claude Code skill Toolkit v6 — คู่มือติดตั้งและใช้งาน (Windows)

> คู่มือสำหรับ Toolkit `ps-*` ที่ติดตั้งระดับผู้ใช้และใช้ซ้ำได้หลาย Repository พร้อม Milestone/Wave, GitHub Issues, role-based coding, E2E และรายงานผล **การติดตั้ง Toolkit ไม่เท่ากับการติดตั้ง third-party tools**

## GitHub distribution — Publish / Install / Update / Uninstall

> **เป้าหมาย:** Push Toolkit ทั้งชุดขึ้น GitHub **ครั้งเดียว** แล้วให้ผู้ใช้ Clone มาติดตั้ง Global Skills/Subagents ใช้ได้ทุก Project ของ Windows User คนนั้น **คำสั่งทั้งหมดในหัวข้อนี้รันใน Windows PowerShell** (ยกเว้นคำสั่งภายใน Claude Code ที่ระบุไว้ต่างหาก) วิธีที่ปลอดภัยคือ **Clone → ตรวจไฟล์ → Run Installer** ไม่ใช่ดาวน์โหลดแล้วรัน Shell Script จากอินเทอร์เน็ตโดยไม่ตรวจสอบ

### Repository layout ที่ต้อง Push ขึ้น GitHub

```text
claude-code-skill-toolkit/
├── README.md
├── install.ps1
├── uninstall.ps1
├── THIRD-PARTY-INTEGRATIONS.md
├── PHASE-3-IMPLEMENTATION-PLAN.md
├── agents/                       # Claude Code global subagents (.md)
├── skills/                       # ps-* skills (แต่ละอันมี SKILL.md)
└── templates/                    # Markdown templates สำหรับ planning/reporting
```

ตรวจให้แน่ใจว่าแตก ZIP แล้วอยู่ในโฟลเดอร์ที่มี `install.ps1`, `uninstall.ps1`, `agents/` และ `skills/` **โดยตรง** ก่อนรันคำสั่งต่าง ๆ อย่านำ `.env`, API keys, credentials, personal `.claude/settings.json`, test artifacts ที่มีข้อมูลจริง หรือไฟล์ส่วนตัวติดขึ้น Repository. แนะนำให้เริ่มต้นด้วย **Private Repository** ก่อนตรวจโค้ดและเอกสารอย่างครบถ้วน

### A. สำหรับเจ้าของ Toolkit — Upload / Publish ไป GitHub (ทำครั้งแรก)

**สิ่งที่ต้องมี:** Git, GitHub CLI (`gh`), GitHub account พร้อมสิทธิ์สร้าง Repository. เปลี่ยน `OWNER` เป็น GitHub username หรือ organization ของคุณ และเปลี่ยนชื่อ repository ได้ตามต้องการ

1. แตก ZIP แล้วเปิด PowerShell **ภายในโฟลเดอร์ Toolkit** ซึ่งมี `README.md` และ `install.ps1` (ไม่ใช่โฟลเดอร์แม่)
2. ตรวจเวอร์ชันและ Login GitHub:

   ```powershell
   git --version
   gh --version
   gh auth login
   gh auth status
   ```

3. ตรวจเนื้อหาและไฟล์ที่จะเผยแพร่ก่อน Commit โดยเฉพาะ Secret, Test Reports และข้อมูลภายในบริษัท:

   ```powershell
   Get-ChildItem -Name
   git status --short     # หากยังไม่เป็น Git repo คำสั่งนี้จะรายงานว่า not a git repository
   ```

4. **สำหรับโฟลเดอร์ที่ยังไม่เคยใช้ Git เท่านั้น** เริ่มต้น Git, Stage **เฉพาะไฟล์ของ Toolkit** และ Commit:

   ```powershell
   git init -b main
   git config user.name
   git config user.email
   # หาก Git ยังไม่มีชื่อ/อีเมล ให้ตั้งค่าด้วย git config user.name "YOUR_NAME"
   # และ git config user.email "YOU@EXAMPLE.COM" (เฉพาะ repository นี้)
   git add README.md install.ps1 uninstall.ps1 THIRD-PARTY-INTEGRATIONS.md PHASE-3-IMPLEMENTATION-PLAN.md agents skills templates
   git diff --cached --stat
   git diff --cached --check
   git commit -m "Publish PS skill Toolkit v6"
   ```

   **ต้องตรวจ Staged Files ก่อน Commit**; ไม่แนะนำ `git add -A` ในโฟลเดอร์ที่อาจมีข้อมูลส่วนตัว หากเป็น Git Repository อยู่แล้ว ให้ตรวจ Branch/Remote/Changes ก่อนและอย่ารัน `git init` หรือเพิ่ม Remote ทับโดยไม่ตั้งใจ

5. สร้าง Repository และ Push ขึ้น GitHub ในคำสั่งเดียว **เมื่อยืนยันชื่อและสิทธิ์แล้ว**:

   ```powershell
   gh repo create OWNER/claude-code-skill-toolkit --private --source=. --remote=origin --push
   gh repo view OWNER/claude-code-skill-toolkit --web
   ```

   `--private` ทำให้ Repository มองเห็นได้เฉพาะผู้มีสิทธิ์ เปลี่ยนเป็น `--public` เฉพาะเมื่อได้ตรวจว่าพร้อมเผยแพร่สาธารณะแล้ว คำสั่ง `gh repo create` ใช้สำหรับ **สร้าง Repo ใหม่เท่านั้น** ไม่ใช้ซ้ำกับ Repo ที่มีอยู่แล้ว

**ทางเลือกหากสร้าง Empty Repository ไว้บนเว็บไซต์ GitHub แล้ว:** อย่ารัน `gh repo create`; ตั้ง Remote/Push จากโฟลเดอร์ Git ที่ Commit แล้ว (เฉพาะเมื่อไม่มี `origin` อยู่ก่อน):

```powershell
git remote -v
git remote add origin https://github.com/OWNER/claude-code-skill-toolkit.git
git push -u origin main
```

ควรสร้าง Repository เปล่าโดยไม่เลือกสร้าง README/License/.gitignore บนเว็บไซต์ ถ้ามี Commit จากฝั่ง GitHub อยู่แล้ว ต้องตรวจและรวม History ให้ถูกต้องก่อน Push **ห้ามใช้ `--force` เพื่อข้ามปัญหา**

### B. สำหรับผู้ใช้งาน — Install จาก GitHub บน Windows เครื่องใหม่

**Prerequisites:** ติดตั้ง Claude Code และ Git แล้ว; หาก Clone Private Repository ต้องมี GitHub authentication และสิทธิ์เข้าถึง Repo. ไม่จำเป็นต้องมี `gh` สำหรับการ Clone Public Repository ผ่าน Git

1. เปิด PowerShell ในโฟลเดอร์สำหรับเก็บ Source (ตัวอย่าง `Documents`):

   ```powershell
   Set-Location (Join-Path $HOME 'Documents')
   git clone https://github.com/OWNER/claude-code-skill-toolkit.git
   Set-Location .\claude-code-skill-toolkit
   ```

   หรือใช้ `gh repo clone OWNER/claude-code-skill-toolkit` แทน `git clone` หาก Login GitHub CLI แล้ว การรัน `git clone` อย่างเดียว **ยังไม่ได้ติดตั้ง Skills**

2. ตรวจ Source ที่ Clone มา ก่อนรันสคริปต์:

   ```powershell
   Get-Content .\install.ps1
   Get-Content .\uninstall.ps1
   Get-ChildItem .\agents
   Get-ChildItem .\skills
   ```

3. ติดตั้ง Global Skills/Subagents:

   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\install.ps1
   ```

   ติดตั้งลง `%USERPROFILE%\.claude\agents\` และ `%USERPROFILE%\.claude\skills\` โดยไม่แก้ไฟล์ใน Repository งานของคุณ หากไฟล์ชื่อเดียวกันมีอยู่ จะ **SKIP** โดยค่าเริ่มต้น ถ้าต้องการแทนที่ให้สำรองก่อน:

   ```powershell
   .\install.ps1 -Force
   ```

   `-Force` จะสำรองไฟล์ที่ถูกแทนที่ไปยัง `~/.claude/skill-v6-backups/<timestamp>/` ก่อนเขียนทับ **ไม่ได้** ติดตั้ง Superpowers, Matt Pocock Skills, gstack, Impeccable, Playwright หรือโปรแกรมภายนอกอัตโนมัติ (ดู Installation matrix และ Step 3 ด้านล่าง)

4. ปิดแล้วเปิด Claude Code ใหม่ **จาก Repository งานใดก็ได้**:

   ```powershell
   claude
   ```

   พิมพ์ `/` ใน Claude Code และค้นหา `/ps-plan-project`, `/ps-plan-waves`, `/ps-implement-wave`, `/ps-e2e-plan` เพื่อเช็กการค้นพบ Skills; ทดสอบ `/ps-check-integrations all` สำหรับ External Plugins ที่เลือกติดตั้งจริง

### C. Update Toolkit เมื่อ GitHub มีเวอร์ชันใหม่

เปิด **PowerShell ในโฟลเดอร์ที่ Clone Toolkit มา (ไม่ใช่โปรเจกต์งาน)** แล้วตรวจว่ามีการแก้ไขไฟล์ภายในโฟลเดอร์หรือไม่:

```powershell
Set-Location (Join-Path $HOME 'Documents\claude-code-skill-toolkit')
git status --short
git pull --ff-only
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1 -Force
```

`git pull --ff-only` จะหยุดหากมี Divergent History และอาจหยุดหากมี Local Edits — ให้ตรวจและแก้ปัญหาก่อน **ห้ามทิ้งการแก้ไขด้วย `git reset --hard`**. `-Force` จะทำ Backup แล้วแทนที่ไฟล์ชื่อเดียวกันที่ติดตั้งอยู่ หากเวอร์ชันใหม่ **เปลี่ยนชื่อหรือลบ Skill** รุ่นเก่าอาจยังค้างอยู่ — ให้ตรวจ `~/.claude/skills` และคำแนะนำ Migration ของ Release นั้น ๆ ก่อนลบอะไร

หลัง Update ให้ Restart Claude Code และตรวจ Slash Commands อีกครั้ง การ Update Source ด้วย `git pull` อย่างเดียว **ไม่** อัปเดต Global Skills ที่เคยติดตั้งไว้

### D. Uninstall Toolkit ที่ติดตั้งจาก GitHub

1. เปิด PowerShell ใน **โฟลเดอร์ Source ที่ Clone ไว้** และตรวจ Script:

   ```powershell
   Set-Location (Join-Path $HOME 'Documents\claude-code-skill-toolkit')
   Get-Content .\uninstall.ps1
   Set-ExecutionPolicy -Scope Process Bypass
   .\uninstall.ps1
   ```

2. `uninstall.ps1` จะเทียบ **SHA-256** ของไฟล์แต่ละ Agent/Skill ใน Global Directory กับไฟล์ Source รุ่นเดียวกันก่อนลบ ดังนั้น:
   - ลบเฉพาะไฟล์ที่ Hash ตรงกัน เพื่อป้องกันการลบงานที่ผู้ใช้ปรับแต่งเอง
   - หากปรากฏ `SKIP modified file` จะ **ไม่ลบไฟล์นั้น** ให้ตรวจและจัดการด้วยตนเองเท่านั้น
   - ถ้าติดตั้งรุ่นเก่า แต่ Source Folder ถูก Update เป็นรุ่นใหม่แล้ว Hash ต่างกัน อาจมีไฟล์รุ่นเก่าค้างอยู่ ให้ใช้ Source ของรุ่นที่เคยติดตั้งก่อน หรือพิจารณาแต่ละไฟล์ด้วยตนเอง
   - **ไม่** ลบ Backups, Third-party Plugins, GitHub Repositories/Issues, Project Source หรือโฟลเดอร์ที่ Clone มา และอาจเหลือ Empty Directories ใน `~/.claude/`

3. Restart Claude Code และตรวจว่า `/ps-*` ที่ถอนแล้วไม่อยู่ในรายการ (หากยังอยู่ ให้ตรวจไฟล์ที่ `SKIP`, การติดตั้งซ้ำจาก Project-level Skills หรือ Cache/Session เก่า)
4. **Optional:** เมื่อไม่มี Local Changes หรือไฟล์สำคัญในโฟลเดอร์ Clone แล้ว สามารถลบโฟลเดอร์ Source ของ Toolkit ด้วยตนเอง; การลบ Source Folder อย่างเดียว **ไม่ใช่การ Uninstall** เพราะ Global Skills/Subagents ยังอยู่

> การถอน Toolkit **ไม่ถอน** `superpowers`, `mattpocock-skills`, `gstack`, `Impeccable`, `Playwright Test`, `Playwright MCP` หรือ Security Plugins. ต้องถอนแต่ละตัวตามคู่มือของเครื่องมือนั้น ๆ และตรวจให้แน่ใจก่อนลบ dependencies ระดับ Project

### E. คำสั่ง Cheat Sheet

| เป้าหมาย | รันที่ไหน | คำสั่ง |
|---|---|---|
| Publish Repo (ครั้งแรก) | PowerShell, Root Toolkit | `gh repo create OWNER/claude-code-skill-toolkit --private --source=. --remote=origin --push` |
| Clone Repo | PowerShell | `git clone https://github.com/OWNER/claude-code-skill-toolkit.git` |
| Install ครั้งแรก | PowerShell, Root Toolkit | `.\install.ps1` |
| Upgrade / Replace (with backup) | PowerShell, Root Toolkit | `.\install.ps1 -Force` |
| Get latest code | PowerShell, Root Toolkit | `git pull --ff-only` |
| Uninstall Toolkit | PowerShell, Root Toolkit | `.\uninstall.ps1` |
| Verify Skills | ภายใน Claude Code | พิมพ์ `/` แล้วค้นหา `/ps-plan-project` |

**Official references:** [GitHub CLI — gh repo create](https://cli.github.com/manual/gh_repo_create) · [GitHub Docs — Add locally hosted code](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github) · [GitHub Docs — Clone a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) · [Claude Code — Skills](https://code.claude.com/docs/en/skills) · [Claude Code — Subagents](https://code.claude.com/docs/en/sub-agents)

---

## เริ่มจากตรงไหน: Installation matrix

| Skill set / เครื่องมือ | What we use it for | อยู่ใน Toolkit ZIP? | ต้อง install เอง? | ตั้งค่าทุก Project? |
|---|---|---|---|---|
| **PS skill Toolkit** | `/ps-plan-project`, `/ps-plan-waves`, `/ps-implement-wave`, E2E reporting และ workflow ทั้ง 15 Skills | **มี** | ลงด้วย `install.ps1` ครั้งเดียว | อ่าน project rules / issue scope ทุกโปรเจกต์ |
| **Claude Code** | AI coding CLI สำหรับเรียก Skills/Subagents | **ไม่มี** | **ต้อง** | เปิดในแต่ละ repo |
| **Git** | อ่าน diff, branches, checkout และ gstack installer | **ไม่มี** | **ต้อง** | repo ต้องเป็น Git repository |
| **GitHub CLI (`gh`)** | อ่าน/สร้าง Issues และ Milestones | **ไม่มี** | **ต้อง** ถ้าใช้ GitHub workflow | ยืนยัน repo และสิทธิ์ GitHub |
| **superpowers** | Planning, systematic debugging, implementation discipline | **ไม่มี** | **ติดตั้งเอง (แนะนำ)** | อาจต้องเลือกใช้ตามงาน |
| **mattpocock-skills** | `/tdd` สร้าง Tests ก่อน Code (Red → Green → Refactor) | **ไม่มี** | **ติดตั้งเอง (แนะนำ)** | **รัน `/setup-matt-pocock-skills` ต่อ repo** |
| **gstack** | `/browse` ตรวจหน้าจอผ่าน browser, `/qa` สำหรับ browser QA | **ไม่มี** | **ติดตั้งเองถ้าต้องการ Browser QA** | ทดสอบ URL / credentials ต่อ environment |
| **Impeccable** | `/impeccable shape`, `audit`, `critique`, `polish` สำหรับ Frontend | **ไม่มี** | **ติดตั้งเองสำหรับ Frontend** | `/impeccable init` เมื่ออนุมัติให้สร้าง project context |
| **Playwright Test** | E2E แบบรันซ้ำได้และ HTML/JSON/JUnit reports | **ไม่มี** | **ติดตั้ง dependency/browser เองใน repo** | **ต้องมี config, scripts, test accounts, environment** |
| **Playwright MCP** | Browser interaction ช่วยสำรวจ/debug เท่านั้น | **ไม่มี** | เลือกติดตั้ง | ตั้ง MCP และสิทธิ์ต่างหาก |
| **Security plugins** | Optional scanning/advice นอกเหนือจาก Agent review ที่ bundled | **ไม่มี** | เลือกติดตั้ง | ตรวจว่าคำสั่งมีจริงก่อนใช้ |

**สำคัญ:** `ps-*` 15 Skills และ Subagents ของ Toolkit จะพร้อมหลัง install ZIP แต่ external skill `/tdd`, `/browse`, `/impeccable` หรือ `superpowers` **ไม่** ถูกดาวน์โหลดหรือเปิดใช้งานอัตโนมัติ และไม่มีการติดตั้ง package/browser โดย `ps-e2e-test` เอง

## Step 0 — ตรวจ Dependencies บน Windows

เปิด **PowerShell** (ไม่จำเป็นต้องเปิดเป็น Administrator) แล้วตรวจ:

```powershell
claude --version
git --version
gh --version
node --version
npm --version
```

ถ้าต้องการ **gstack** ให้ตรวจเพิ่มเติม `bun --version` และ `node --version` (Windows ต้องใช้ Node.js ด้วย) หากคำสั่งหายไป ให้ติดตั้งจากผู้พัฒนาอย่างเป็นทางการและตรวจ PATH ก่อนทำต่อ คำสั่ง `/plugin` ด้านล่างต้องพิมพ์ **ภายใน Claude Code** ไม่ใช่ PowerShell

## Step 1 — ติดตั้ง PS skill Toolkit (ครั้งเดียวต่อ Windows User)

แตก ZIP **หรือ Clone จาก GitHub (ดูหัวข้อ GitHub distribution ด้านบน)** แล้วเปิด PowerShell ที่โฟลเดอร์ซึ่งมี `install.ps1`:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

หากต้องการสำรองไฟล์เดิมแล้วเขียนทับไฟล์ Toolkit ชื่อเดียวกัน:

```powershell
.\install.ps1 -Force
```

ติดตั้งที่ `%USERPROFILE%\.claude\agents\` และ `%USERPROFILE%\.claude\skills\` แล้ว **Restart Claude Code**; ตรวจรายการด้วยการพิมพ์ `/` และค้นหา `/ps-plan-project` กับ `/ps-e2e-plan`. **อย่ารัน `-Force` โดยไม่ตรวจการแก้ไขของตนเอง** การติดตั้งนี้ไม่ลงโปรแกรมภายนอกและไม่ Login GitHub ให้

## Step 2 — GitHub Setup (จำเป็นเมื่อใช้ GitHub Issues/Milestones)

```powershell
gh auth login
gh auth status
gh repo view OWNER/REPO
```

ยืนยันว่า Repository เป้าหมายถูกต้องและมี Permission เพียงพอ ก่อน `/ps-create-issues` หรือ `/ps-create-milestones` ซึ่งเป็นการเขียนข้อมูลลง GitHub จริง; Toolkit ต้องแสดงรายการที่จะเขียนและได้รับ User Approval ต่างหาก

## Step 3 — ติดตั้ง External Skill Sets (แยกจาก Toolkit)

### A. Superpowers — Recommended for planning & debugging

**Where:** เปิด `claude` แล้วป้อนทีละบรรทัด:

```text
/plugin install superpowers@claude-plugins-official
```

ตรวจจากเมนู `/plugin` ว่าติดตั้งสำเร็จ หาก package/channel เปลี่ยนให้ใช้รายการปัจจุบันใน marketplace ห้ามอ้างว่าเรียกได้จนตรวจเห็นจริง

### B. Matt Pocock Skills — Recommended `/tdd`

**Where:** ภายใน Claude Code (ทีละบรรทัด):

```text
/plugin marketplace add mattpocock/skills
/plugin install mattpocock-skills@mattpocock
```

**ต่อ Repository:** เปิด Claude Code ในแต่ละ Repository ที่ต้องการใช้ แล้วรัน:

```text
/setup-matt-pocock-skills
```

ตอบคำถาม setup ตาม Issue Tracker/labels/docs destination ของโปรเจกต์ ตรวจด้วยการพิมพ์ `/tdd`. การติดตั้ง Plugin แบบ Global ไม่ได้แปลว่า setup per-repository เสร็จแล้ว ดู: https://github.com/mattpocock/skills

### C. gstack — Optional `/browse` และ Browser QA

**Prerequisites:** Git, **Bun v1+**, และ **Node.js บน Windows**; ให้ใช้ **Git Bash หรือ WSL** สำหรับ `./setup` — ไม่ใช่คำสั่ง PowerShell ตรง ๆ. อ่าน README ผู้พัฒนาก่อนรัน เพราะ setup จะดาวน์โหลด/สร้าง binary และ Browser components.

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack
./setup
```

หากโฟลเดอร์ `~/.claude/skills/gstack` มีอยู่แล้ว **ห้าม clone ทับ** ให้ทำตามคู่มือ Update ของ upstream. gstack มีคำสั่ง `/qa` และ `/browse`; ห้ามใช้ `/ship`, deploy หรือคำสั่งเปลี่ยน production จาก Workflow โดยไม่ได้อนุมัติ การใช้ gstack บน Windows 11 รองรับผ่าน Git Bash/WSL ตาม README. ดู: https://github.com/garrytan/gstack

### D. Impeccable — Optional Frontend UX/UI

**Where:** PowerShell; ให้ Node/npm/npx พร้อมก่อน:

```powershell
npx impeccable install --providers=claude --scope=global
```

ตรวจ upstream installer/permissions ก่อนตอบตกลง แล้ว Restart Claude Code; ตรวจ `/impeccable` จากรายการคำสั่ง หากเริ่มกับ Project ใหม่และอนุมัติการสร้าง context file แล้วให้เรียก:

```text
/impeccable init
```

เลือกติดตั้งด้วย **วิธีเดียว** เพื่อเลี่ยง duplicate skills. ต่อ Frontend Wave ใช้ `shape` ในช่วงวาง UI, `audit`/`critique` ในช่วงตรวจ และ `polish` เฉพาะเมื่ออนุมัติแก้ Code. ดู: https://github.com/pbakaus/impeccable

### E. Playwright Test — Necessary for reproducible E2E runs

**Where:** PowerShell ใน **Repository ที่จะทดสอบ**. ใช้ package manager ของ repo และตรวจ `package.json` ก่อน; สำหรับ npm repo ที่ยังไม่มี Playwright Test:

```powershell
npm init playwright@latest
```

คำสั่งนี้สามารถสร้าง/แก้ไฟล์ Project และติดตั้ง Dependencies จึงต้องได้รับอนุมัติจากเจ้าของ Repository ก่อน สำหรับ Repo ที่มี Playwright อยู่แล้วให้ใช้ script/config เดิมแทนการ init ใหม่ ตรวจว่า Web App/Backend ทำงานใน approved local/staging environment และมี test accounts ที่ปลอดภัย:

```powershell
npx playwright test
npx playwright test --reporter=html
npx playwright show-report
```

ติดตั้ง Browser binaries ตามข้อความของ Playwright หากขาด เช่น `npx playwright install`; ห้ามให้ Toolkit auto-install package/browser หรือรัน E2E กับ production โดยไม่ยืนยัน environment. HTML/JSON/JUnit เป็น **reporter ของ Playwright Test**; `gstack /browse` และ Playwright MCP ไม่ใช่สิ่งทดแทน test-runner. Docs: https://playwright.dev/docs/intro และ https://playwright.dev/docs/test-reporters

### F. Optional: Security review tooling

Toolkit มี `security-reviewer` Subagent แบบ read-only อยู่แล้ว โดย **ไม่ต้องลง plugin เพิ่ม**; สามารถใช้ `/ps-review-code` ได้ทันทีหลังติดตั้ง Toolkit. ถ้าต้องการ plugins/scanners เพิ่ม ให้ตรวจจาก Claude Code `/plugin` และเอกสารผู้พัฒนาปัจจุบันก่อนเสมอ ชื่อ availability และวิธี install อาจเปลี่ยน; อย่าสมมติว่า command `/security-review` หรือ `/claude-security` มีในเครื่องโดยไม่ได้ตรวจ และอย่าสรุปว่า security PASS เท่ากับปลอดภัยสมบูรณ์

## Step 4 — Health checks หลังติดตั้ง

Restart Claude Code แล้วเปิดแต่ละ Repository:

```text
/ps-check-integrations all
```

จากนั้นพิมพ์ `/` เพื่อตรวจว่า `/ps-plan-waves`, `/ps-implement-wave`, `/ps-e2e-test`, `/tdd`, `/browse`, `/impeccable` **ที่เลือกติดตั้ง** ปรากฏจริง. การมี slash command ในรายการไม่ได้พิสูจน์ว่ารัน tests/browser ได้ — ต้องลอง verification ที่ได้รับอนุญาต. หาก dependency ที่งานต้องใช้ยังไม่พร้อมให้รายงาน `BLOCKED` พร้อมคำสั่งติดตั้งที่ขาด แทนการเดาว่าผ่านแล้ว

## Step 5 — Full Workflow end-to-end

| Phase | Commands | Expected artifact/decision |
|---|---|---|
| Discovery & Planning | `/ps-plan-project` | Master Plan, assumptions, issue proposals |
| Milestone & Wave Planning | `/ps-plan-waves OWNER/REPO` | milestone/wave table, dependencies, role ownership |
| **Approval Gate** | User reviews exact issue + milestone manifest | STOP until explicit approval |
| GitHub Publishing | `/ps-create-issues`, `/ps-create-milestones OWNER/REPO` | Actual URLs/IDs, verified; STOP |
| Implementation queue | `/ps-implementation-table OWNER/REPO` | Dependency-ordered Issue table; approval |
| Implementation | `/ps-implement-wave W1 --role frontend` or `/ps-implement-issue 123 --role backend` | Role-scoped diffs and evidence |
| Verification | `/ps-verify-issue 123`, `/ps-review-code` | Actual code/tests findings |
| E2E | `/ps-e2e-plan W1`, `/ps-e2e-test W1 --env staging`, `/ps-e2e-report W1`, `/ps-e2e-verify W1` | Test evidence, report and defects |
| Quality Gate | `/ps-e2e-gate W1` | PASS / FAIL / BLOCKED; STOP |

**Wave vs Milestone:** Milestone คือ Deliverable/เป้าหมายใน GitHub ส่วน Wave คือ Batch ที่จัดตาม Dependencies สำหรับลงมือทำ. **Role ที่บังคับ:** `backend`, `frontend`, `database`, `qa`, `devops`. ไม่มีคำสั่งใดควรปิด Issue/merge/push/deploy หรือเริ่ม Wave ถัดไปอัตโนมัติ

ตัวอย่างคำสั่ง (เลข Issues เป็นสมมติเท่านั้น):

```text
/ps-plan-project
/ps-plan-waves OWNER/REPO
/ps-implementation-table OWNER/REPO
# Approved: Wave W1, frontend scope only
/ps-implement-wave W1 --role frontend
/ps-e2e-plan W1
/ps-e2e-test W1 --env staging
/ps-e2e-report W1
/ps-e2e-verify W1
/ps-e2e-gate W1
```

## Troubleshooting

| Symptom | What to check |
|---|---|
| `ps-*` missing | Confirm extracted ZIP, `install.ps1` success, `~/.claude/skills` and restart Claude Code |
| `/tdd` missing | Verify Matt Pocock plugin + `/setup-matt-pocock-skills` for this repository |
| `/browse` missing | Verify Bun/Node/Git and gstack `./setup` in Git Bash/WSL; restart |
| `/impeccable` missing | Check install scope/provider, duplicates, then restart Claude Code |
| `gh` unauthorized | `gh auth status`, `gh repo view OWNER/REPO`, permission scope |
| E2E `BLOCKED` | Playwright dependency/browser, config, test data, authorized staging URL, running server |
| Reports empty | Confirm actual executed run/artifact directory and reporter; never fabricate PASS |
| Plugin command fails | Re-check current upstream commands in `/plugin` and official project README |

## Security & maintenance

- Review external plugin permissions, hooks, `npx` installers, and shell scripts before allowing execution. **No third-party installation is automatic**.
- Maintain per-repo `CLAUDE.md` for architecture/roles, environment rules and deployment controls.
- Never store real passwords, API keys, payment details or session cookies in committed E2E reports/screenshots/traces.
- A PASS requires actual execution evidence; BLOCKED/PARTIAL are acceptable and preferable to invented results.
- Use `uninstall.ps1` to remove Toolkit-owned files; plugin uninstall/update follows each upstream tool separately.

---

## Full v6 workflow/reference material (retained from prior version)

# Claude Code skill Toolkit v6 — PS Waves + Impeccable + E2E Testing

Reusable **global Claude Code Subagents and Skills**, designed for a two-stage GitHub Issues workflow with human approval gates and mandatory role-based implementation.

Documentation references: [Create custom subagents](https://code.claude.com/docs/en/sub-agents), [Skills](https://code.claude.com/docs/en/skills), [GitHub CLI](https://cli.github.com/manual/gh_issue_create).

## Install once; use in multiple projects

**Requirements:** Claude Code, Windows PowerShell 5.1+ or PowerShell 7, Git, and an authenticated GitHub CLI (`gh`) to read or create real GitHub Issues. Each repository needs its own applicable GitHub permissions.

1. Extract the toolkit ZIP.
2. Open PowerShell **inside the extracted folder** containing `install.ps1`.
3. Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
```

If same-named files already exist, the installer skips them. To back up and replace existing toolkit files:

```powershell
.\install.ps1 -Force
```

Restart Claude Code after installation. Global files are installed to `%USERPROFILE%\.claude\agents\` and `%USERPROFILE%\.claude\skills\`, allowing the same Skills to be invoked inside different projects. Project-specific `CLAUDE.md` and repository rules still apply. No Administrator privileges are needed.

To check GitHub access before working with Issues:

```powershell
gh auth status
gh repo view OWNER/REPO
```

If not authenticated, run `gh auth login` and grant the necessary repository access.

## Full workflow

### Phase 1 — Plan → GitHub Issues

1. Project Discovery — inspect project, architecture, docs, and Git state.
2. Planner Agent — propose epics, tasks, dependencies, acceptance criteria.
3. Plan Validation — flag duplicates, missing architecture decisions, conflicting dependencies.
4. **STOP → User Approval** — no GitHub writes before explicit approval.
5. GitHub Issue Creator — create **only** the approved issues after checking for duplicates.
6. Verify → Report → **STOP** — inspect actually created Issues and give their URLs; do not launch implementation automatically.

```text
/ps-plan-project Analyze this repository and prepare a GitHub Issue plan. Do not publish yet.
# Review and approve the plan explicitly.
/ps-create-issues Create only the GitHub Issues in the approved plan for OWNER/REPO.
```

### Phase 2 — Create the implementation table

Use the real GitHub Issues to define sequencing, ownership, dependencies, priority, acceptance criteria and execution status, split by **backend**, **frontend**, **database**, **qa**, and **devops**.

```text
/ps-implementation-table OWNER/REPO
```

Review the resulting table and **approve it before implementation**. Follow actual dependencies rather than assuming a fixed role order. See [PHASE-3-IMPLEMENTATION-PLAN.md](PHASE-3-IMPLEMENTATION-PLAN.md) for a ready-to-adapt template and detailed gates.

### Phase 3 — Implement exactly one Issue and one Role

`/ps-implement-issue` **requires** one valid Issue and an explicit `--role`. The Skill must stop if either is missing, dependencies or architecture decisions are unresolved, or the scope includes another Role.

The following Issue IDs are **examples, not verified GitHub records**:

```text
/ps-implement-issue 123 --role backend
/ps-implement-issue 124 --role frontend
/ps-implement-issue 125 --role database
/ps-implement-issue 126 --role qa
/ps-implement-issue 127 --role devops
```

**These are examples of Role syntax, not an instruction to run all five sequentially.** Follow your approved dependency-ordered table and run each Issue individually. For example, when #123 depends on #125, implement the database work first:

```text
/ps-implement-issue 125 --role database
# Review reported checks and explicitly approve the next task.
/ps-implement-issue 123 --role backend
```

Each implementation runs project discovery → issue/role validation → scope approval → developer changes → tests → independent code/security reviews → Issue verification → **report and STOP**.

### Phase 4 — Verification (read-only)

```text
/ps-verify-issue 123
/ps-review-code
```

## Skills catalog

| Skill | Purpose | Side effects |
|---|---|---|
| `/ps-plan-project` | Discovery, planning and plan review | Read-only planning |
| `/ps-create-issues` | Create approved Issues from Plan | **GitHub write only after approval** |
| `/ps-implementation-table` | Sequence actual Issues by Role and dependency | Read-only; stops for approval |
| `/ps-implement-issue <number> --role <role>` | Implement one approved Issue and Role | Local code changes in approved scope |
| `/ps-verify-issue <number>` | Verify acceptance criteria against code/tests | Read-only |
| `/ps-review-code` | Code/security review | Read-only |

## Role contract

| Role | Primary scope | Restricted operations |
|---|---|---|
| `backend` | API, services, business rules, auth | No unapproved UI/schema updates |
| `frontend` | UI, pages, client logic, accessibility | No unapproved backend/schema updates |
| `database` | Schema migrations, queries, indexes | No production/shared DB migration execution |
| `qa` | Tests, test data, regression and defects | No silent changes to application code |
| `devops` | CI/CD files, Docker, IaC, monitoring config | No production deployments |

### Safety and STOP conditions

- Do not fabricate Issues; read GitHub with `gh` or ask for exact Issue text.
- Do not begin edits without approved Issue+Role scope and satisfied prerequisites.
- Do not cross-edit other Roles. If an Issue needs multiple Roles, create approved separate work rows or subissues.
- Do not automatically close/change/comment Issues; commit, push, merge, deploy, or execute destructive operations.
- Report exact checks performed and actual results; report `BLOCKED` or `PARTIAL` when appropriate.
- Subagent instructions are **not** a tool-permission sandbox. Configure Claude Code permissions for critical operations.

## Example role-oriented implementation table

| Order | Example Issue | Role | Depends on | Acceptance evidence | Status |
|---|---|---|---|---|---|
| 1 | #125 | database | — | Migration checks | PENDING |
| 2 | #123 | backend | #125 | API tests | PENDING |
| 3 | #124 | frontend | #123 | Build and UI tests | PENDING |
| 4 | #126 | qa | #123, #124 | Regression tests | PENDING |
| 5 | #127 | devops | #126 | CI validation | PENDING |

**Note:** This is a hypothetical example. Do not use these dependencies as facts about any actual repository. See [PHASE-3-IMPLEMENTATION-PLAN.md](PHASE-3-IMPLEMENTATION-PLAN.md) for the full execution checklist.

## Uninstall and migration

See **GitHub distribution → D. Uninstall Toolkit** above for step-by-step instructions. Run `uninstall.ps1` from this extracted package. It removes installed Toolkit files only if they still match the bundled hashes; modified files and backups are preserved. If the previous non-`ps-` version was installed, run its original `uninstall.ps1` first or review its old Skill names manually so commands do not conflict.

## References

- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/skills
- https://cli.github.com/manual/gh_issue_view
- https://cli.github.com/manual/gh_issue_create

## V3: Milestone and Wave workflow

Milestone = outcome/deliverable tracked as a GitHub Milestone. Wave = dependency-aware implementation batch scoped to one milestone. Waves are **not** automatically represented as GitHub Milestones; GitHub milestones are actual remote records, while waves are the local/approved execution plan.

Run in this order:

```text
/ps-plan-project
/ps-plan-waves OWNER/REPO
# Review tables and explicitly approve the plan.
/ps-create-issues
# Review and explicitly approve the exact GitHub write manifest.
/ps-create-milestones OWNER/REPO
/ps-implementation-table OWNER/REPO
/ps-implement-wave W1 --role database
/ps-implement-issue 123 --role backend
/ps-verify-issue 123
/ps-review-code
```

Use `/ps-create-issues` before milestone assignment if planned issues do not yet have real GitHub IDs. `ps-create-milestones` must verify issue IDs before assignments. Publication and execution require distinct human approval gates. Missing dependencies or unverified GitHub access = BLOCKED, not a guessed result.

Wave planning artifact: `templates/MILESTONE-WAVE-PLAN.md`. Extra agents: `wave-planner` (Opus), `milestone-publisher` (Sonnet). Global install uses `install.ps1 -Force` with backups for replacements.

Reference: https://code.claude.com/docs/en/sub-agents and https://code.claude.com/docs/en/skills and https://docs.github.com/en/rest/issues/milestones


## Optional integrations: Superpowers, Matt Pocock, gstack

The toolkit keeps all `ps-*` commands and approval gates. Third-party tools are **not bundled or auto-installed**. See [THIRD-PARTY-INTEGRATIONS.md](THIRD-PARTY-INTEGRATIONS.md) for reviewed installation steps and Windows prerequisites. Run `/ps-check-integrations` before any task where `/tdd` or `/browse` is required. Never assume third-party skills are available before checking inside Claude Code.


## Optional Impeccable frontend integration (v5)

Only `--role frontend` enables the Impeccable integration. Install separately after reviewing upstream sources:

```powershell
npx impeccable install --providers=claude --scope=global
```

Restart Claude Code and check `/impeccable` is available. Per project, use `/impeccable init` with explicit consent since it writes design-context files. Then:

```text
/ps-check-integrations impeccable
/ps-implement-wave W1 --role frontend
```

The wave planner should invoke Impeccable's `shape` (plan), `audit` and `critique` (validate), and optionally `polish`/`harden` (approved changes), without bypassing issue approval, tests, independent reviews or STOP gates. If Impeccable is required but missing, report `BLOCKED`. Full instructions: [THIRD-PARTY-INTEGRATIONS.md](THIRD-PARTY-INTEGRATIONS.md).


## Phase 4 — E2E Testing + Evidence Reports + Gate (v6)

The toolkit now includes **five new global skills** and three E2E-focused subagents. These skills are workflow instructions; they do not install Playwright or configure your project automatically. Use an approved local/staging environment and repository-native Playwright setup.

| Skill | Purpose |
|---|---|
| `/ps-e2e-plan W1` | Map real GitHub Issue acceptance criteria to cases and a test plan |
| `/ps-e2e-test W1 --env staging` | Execute approved existing Playwright tests and collect machine-readable evidence |
| `/ps-e2e-report W1` | Summarize JSON/JUnit/HTML results and defect findings, no fictional PASS |
| `/ps-e2e-verify W1` | Map criteria to executed tests and actual results |
| `/ps-e2e-gate W1` | PASS / FAIL / BLOCKED and STOP; no automatic issue closure or next wave |

A typical approved flow:

```text
/ps-implement-wave W1 --role frontend
/ps-e2e-plan W1
# Approve test setup and local/staging test execution.
/ps-e2e-test W1 --env staging
/ps-e2e-report W1
/ps-e2e-verify W1
/ps-e2e-gate W1
```

**Dependencies:** Node.js, an already configured Playwright Test dependency, browser binaries, active authorized local/staging environment, and safe test accounts/data. The toolkit installer does not run `npm install`, `npx playwright install`, or tests. If prerequisites are absent, the E2E step returns BLOCKED and explains why. `/browse` and Playwright MCP are optional helpers, not replacements for a reproducible Playwright Test run.

**Report artifacts:** Prefer unique `reports/W1/runs/<UTC-run-id>/` for raw JSON, JUnit and HTML, and `reports/W1/E2E-TEST-REPORT.md` for the summary after explicit permission to write results. Report templates live in `templates/`. Some reports can contain secrets; review before committing or uploading.

Playwright documentation: https://playwright.dev/docs/test-reporters and https://playwright.dev/docs/test-cli.
