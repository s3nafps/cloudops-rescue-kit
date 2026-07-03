Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$repoRoot = Split-Path -Parent $PSScriptRoot
$outputDir = Join-Path $repoRoot "screenshots\public"

if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

function New-TerminalShot {
  param(
    [string]$Path,
    [string]$Title,
    [string[]]$Lines,
    [string]$AccentHex = "#6ee7b7"
  )

  $width = 1500
  $lineHeight = 28
  $height = 160 + ($Lines.Count * $lineHeight)
  if ($height -lt 520) { $height = 520 }

  $bmp = New-Object System.Drawing.Bitmap $width, $height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $bg = [System.Drawing.ColorTranslator]::FromHtml("#0b1020")
  $panel = [System.Drawing.ColorTranslator]::FromHtml("#111827")
  $panelAlt = [System.Drawing.ColorTranslator]::FromHtml("#0f172a")
  $text = [System.Drawing.ColorTranslator]::FromHtml("#e5eefc")
  $muted = [System.Drawing.ColorTranslator]::FromHtml("#94a3b8")
  $accent = [System.Drawing.ColorTranslator]::FromHtml($AccentHex)

  $g.Clear($bg)
  $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70, 0, 0, 0))
  $g.FillRectangle($shadowBrush, 55, 55, 1390, $height - 110)

  $panelBrush = New-Object System.Drawing.SolidBrush $panel
  $topBrush = New-Object System.Drawing.SolidBrush $panelAlt
  $textBrush = New-Object System.Drawing.SolidBrush $text
  $mutedBrush = New-Object System.Drawing.SolidBrush $muted
  $accentBrush = New-Object System.Drawing.SolidBrush $accent
  $redBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#fb7185"))
  $amberBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#fbbf24"))
  $greenBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#34d399"))

  $g.FillRectangle($panelBrush, 45, 45, 1410, $height - 90)
  $g.FillRectangle($topBrush, 45, 45, 1410, 72)

  $titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 18)
  $bodyFont = New-Object System.Drawing.Font("Consolas", 16)
  $smallFont = New-Object System.Drawing.Font("Segoe UI", 12)

  $g.FillEllipse($redBrush, 72, 71, 14, 14)
  $g.FillEllipse($amberBrush, 98, 71, 14, 14)
  $g.FillEllipse($greenBrush, 124, 71, 14, 14)
  $g.DrawString($Title, $titleFont, $textBrush, 165, 62)
  $g.DrawString("CloudOps Rescue Kit public evidence", $smallFont, $mutedBrush, 1085, 66)

  $y = 145
  foreach ($line in $Lines) {
    if ($line.StartsWith("`$ ")) {
      $g.DrawString("`$ ", $bodyFont, $accentBrush, 80, $y)
      $g.DrawString($line.Substring(2), $bodyFont, $textBrush, 110, $y)
    }
    elseif ($line.StartsWith("# ")) {
      $g.DrawString($line.Substring(2), $bodyFont, $accentBrush, 80, $y)
    }
    else {
      $g.DrawString($line, $bodyFont, $textBrush, 80, $y)
    }
    $y += $lineHeight
  }

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $titleFont.Dispose()
  $bodyFont.Dispose()
  $smallFont.Dispose()
  $shadowBrush.Dispose()
  $panelBrush.Dispose()
  $topBrush.Dispose()
  $textBrush.Dispose()
  $mutedBrush.Dispose()
  $accentBrush.Dispose()
  $redBrush.Dispose()
  $amberBrush.Dispose()
  $greenBrush.Dispose()
  $g.Dispose()
  $bmp.Dispose()
}

function New-DashboardShot {
  param(
    [string]$Path
  )

  $width = 1500
  $height = 920
  $bmp = New-Object System.Drawing.Bitmap $width, $height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $bg = [System.Drawing.ColorTranslator]::FromHtml("#08111f")
  $panel = [System.Drawing.ColorTranslator]::FromHtml("#111827")
  $card = [System.Drawing.ColorTranslator]::FromHtml("#0f172a")
  $line = [System.Drawing.ColorTranslator]::FromHtml("#1f2937")
  $text = [System.Drawing.ColorTranslator]::FromHtml("#e5eefc")
  $muted = [System.Drawing.ColorTranslator]::FromHtml("#94a3b8")
  $green = [System.Drawing.ColorTranslator]::FromHtml("#34d399")
  $amber = [System.Drawing.ColorTranslator]::FromHtml("#fbbf24")

  $g.Clear($bg)
  $panelBrush = New-Object System.Drawing.SolidBrush $panel
  $cardBrush = New-Object System.Drawing.SolidBrush $card
  $linePen = New-Object System.Drawing.Pen $line, 2
  $textBrush = New-Object System.Drawing.SolidBrush $text
  $mutedBrush = New-Object System.Drawing.SolidBrush $muted
  $greenBrush = New-Object System.Drawing.SolidBrush $green
  $amberBrush = New-Object System.Drawing.SolidBrush $amber

  $titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 24)
  $bodyFont = New-Object System.Drawing.Font("Segoe UI", 16)
  $smallFont = New-Object System.Drawing.Font("Segoe UI", 12)

  $g.FillRectangle($panelBrush, 40, 40, 1420, 840)
  $g.DrawString("Monitoring dashboard", $titleFont, $textBrush, 70, 70)
  $g.DrawString("Uptime Kuma style public mock for CloudOps Rescue Kit", $bodyFont, $mutedBrush, 70, 112)

  $cards = @(
    @{ x = 70; y = 180; title = "api.example-client.com/health"; status = "UP"; ms = "182 ms"; brush = $greenBrush },
    @{ x = 70; y = 330; title = "api.example-client.com/login"; status = "UP"; ms = "244 ms"; brush = $greenBrush },
    @{ x = 70; y = 480; title = "api.example-client.com/docs"; status = "UP"; ms = "201 ms"; brush = $greenBrush },
    @{ x = 780; y = 180; title = "Alert routing"; status = "TESTED"; ms = "Email ok"; brush = $amberBrush }
  )

  foreach ($item in $cards) {
    $g.FillRectangle($cardBrush, $item.x, $item.y, 620, 120)
    $g.DrawRectangle($linePen, $item.x, $item.y, 620, 120)
    $g.DrawString($item.title, $bodyFont, $textBrush, $item.x + 24, $item.y + 24)
    $g.DrawString($item.status, $bodyFont, $item.brush, $item.x + 24, $item.y + 62)
    $g.DrawString($item.ms, $bodyFont, $mutedBrush, $item.x + 470, $item.y + 62)
  }

  $g.DrawString("Operator note: if 2 consecutive checks fail, investigate proxy logs first, then app container state.", $bodyFont, $mutedBrush, 70, 690)
  $g.DrawString("This asset is redacted demo evidence, safe for public portfolio use.", $smallFont, $mutedBrush, 70, 740)

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $panelBrush.Dispose()
  $cardBrush.Dispose()
  $linePen.Dispose()
  $textBrush.Dispose()
  $mutedBrush.Dispose()
  $greenBrush.Dispose()
  $amberBrush.Dispose()
  $titleFont.Dispose()
  $bodyFont.Dispose()
  $smallFont.Dispose()
  $g.Dispose()
  $bmp.Dispose()
}

function New-DocumentShot {
  param(
    [string]$Path,
    [string]$Title,
    [string[]]$Lines
  )

  $width = 1400
  $height = 1700
  $bmp = New-Object System.Drawing.Bitmap $width, $height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $bg = [System.Drawing.ColorTranslator]::FromHtml("#dbe4f0")
  $paper = [System.Drawing.Color]::White
  $text = [System.Drawing.ColorTranslator]::FromHtml("#0f172a")
  $muted = [System.Drawing.ColorTranslator]::FromHtml("#475569")
  $accent = [System.Drawing.ColorTranslator]::FromHtml("#0f766e")

  $g.Clear($bg)
  $paperBrush = New-Object System.Drawing.SolidBrush $paper
  $textBrush = New-Object System.Drawing.SolidBrush $text
  $mutedBrush = New-Object System.Drawing.SolidBrush $muted
  $accentBrush = New-Object System.Drawing.SolidBrush $accent

  $titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 30)
  $bodyFont = New-Object System.Drawing.Font("Segoe UI", 18)
  $smallFont = New-Object System.Drawing.Font("Segoe UI", 14)

  $g.FillRectangle($paperBrush, 85, 60, 1230, 1560)
  $g.DrawString($Title, $titleFont, $textBrush, 140, 120)
  $g.DrawString("CloudOps Rescue Kit public deliverable sample", $smallFont, $mutedBrush, 140, 176)
  $g.DrawString("Redacted demonstration output", $smallFont, $accentBrush, 1000, 176)

  $y = 250
  foreach ($line in $Lines) {
    if ($line.StartsWith("# ")) {
      $g.DrawString($line.Substring(2), $bodyFont, $accentBrush, 140, $y)
      $y += 36
      continue
    }
    $g.DrawString($line, $bodyFont, $textBrush, 140, $y)
    $y += 32
  }

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $paperBrush.Dispose()
  $textBrush.Dispose()
  $mutedBrush.Dispose()
  $accentBrush.Dispose()
  $titleFont.Dispose()
  $bodyFont.Dispose()
  $smallFont.Dispose()
  $g.Dispose()
  $bmp.Dispose()
}

$terminalShots = @(
  @{
    file = "01-diagnostics-run.png"
    title = "01 Diagnostics run"
    lines = @(
      "`$ ./scripts/collect-diagnostics.sh",
      "# host summary",
      "hostname: vps-redacted-01",
      "os: Ubuntu 24.04 LTS",
      "docker: active",
      "compose projects: orders-api",
      "disk rootfs: 61% used",
      "memory: 2.1 GiB free / 8 GiB",
      "open ports: 22, 80, 443",
      "report written: reports/20260703T161000Z"
    )
  },
  @{
    file = "02-report-folder.png"
    title = "02 Report folder"
    lines = @(
      "`$ ls reports/20260703T161000Z",
      "docker-ps.txt",
      "docker-compose-ps.txt",
      "disk.txt",
      "memory.txt",
      "ports.txt",
      "healthcheck.txt",
      "summary.txt"
    )
  },
  @{
    file = "03-container-before.png"
    title = "03 Container state before fix"
    lines = @(
      "`$ docker ps -a",
      "NAME            STATUS                      PORTS",
      "orders-api      Up 3 minutes (healthy)     8080/tcp",
      "reverse-proxy   Up 3 minutes               0.0.0.0:443->443/tcp",
      "worker          Exited (1) 12 minutes ago  -",
      "",
      "# operator note",
      "Public endpoint is failing even though app container is healthy."
    )
  },
  @{
    file = "04-healthcheck-failed.png"
    title = "04 Failed health check"
    lines = @(
      "`$ ./scripts/health-check.sh monitoring/endpoints.example.txt",
      "https://api.example-client.com/health  FAIL  502 Bad Gateway",
      "https://api.example-client.com/login   FAIL  502 Bad Gateway",
      "",
      "# summary",
      "2 endpoint checks failing before remediation"
    )
  },
  @{
    file = "05-fix-applied.png"
    title = "05 Scoped fix applied"
    lines = @(
      '`$ grep -n "orders-api" Caddyfile',
      "12: reverse_proxy orders-api:8000",
      '`$ sed -i ''s/orders-api:8000/orders-api:8080/'' Caddyfile',
      "`$ docker compose exec reverse-proxy caddy validate --config /etc/caddy/Caddyfile",
      "valid configuration",
      "`$ docker compose restart reverse-proxy",
      "Container reverse-proxy  Restarting",
      "Container reverse-proxy  Started"
    )
  },
  @{
    file = "06-healthcheck-passed.png"
    title = "06 Passing health check"
    lines = @(
      "`$ ./scripts/health-check.sh monitoring/endpoints.example.txt",
      "https://api.example-client.com/health  OK   200  182 ms",
      "https://api.example-client.com/login   OK   200  244 ms",
      "https://api.example-client.com/docs    OK   200  201 ms",
      "",
      "# summary",
      "All monitored endpoints passing after proxy update"
    )
  },
  @{
    file = "07-backup-created.png"
    title = "07 Backup created"
    lines = @(
      "`$ ./scripts/backup-compose-volumes.sh orders-api",
      "project: orders-api",
      "volume: orders-api_db-data",
      "archive: backups/orders-api-20260703T171500Z/orders-api_db-data.tar.gz",
      "sha256: backups/orders-api-20260703T171500Z/SHA256SUMS",
      "result: backup complete"
    )
  },
  @{
    file = "08-checksum-verified.png"
    title = "08 Checksum verified"
    lines = @(
      "`$ sha256sum -c backups/orders-api-20260703T171500Z/SHA256SUMS",
      "orders-api_db-data.tar.gz: OK",
      "",
      "# evidence",
      "Backup artifact integrity verified before restore test"
    )
  },
  @{
    file = "09-restore-test.png"
    title = "09 Restore test"
    lines = @(
      "`$ RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh backups/orders-api-20260703T171500Z/orders-api_db-data.tar.gz orders-api_restore_test",
      "created volume: orders-api_restore_test",
      "restored archive into disposable target",
      "verification file: index.html",
      "result: restore test complete"
    )
  }
)

foreach ($shot in $terminalShots) {
  New-TerminalShot -Path (Join-Path $outputDir $shot.file) -Title $shot.title -Lines $shot.lines
}

New-DashboardShot -Path (Join-Path $outputDir "10-monitoring-dashboard.png")

$docLines = @(
  "# Summary",
  "Public API returned 502 before fix; proxy upstream target used the old internal port.",
  "",
  "# Root cause",
  "reverse_proxy still pointed to orders-api:8000 while the app now listened on 8080.",
  "",
  "# Fix applied",
  "Updated proxy target, validated config, restarted proxy, re-ran endpoint checks.",
  "",
  "# Verification",
  "health endpoint 200 OK, login 200 OK, docs 200 OK, no new proxy upstream errors.",
  "",
  "# Remaining risks",
  "no tested restore proof before this engagement; no alerting configured before baseline setup.",
  "",
  "# Next actions",
  "add restore-tested backup, store proxy config in version control, keep first-response notes with the app."
)
New-DocumentShot -Path (Join-Path $outputDir "11-incident-report.png") -Title "Incident report and handover sample" -Lines $docLines

$testPath = Join-Path $outputDir "_test.png"
if (Test-Path $testPath) {
  Remove-Item $testPath -Force
}

Write-Output "Generated public evidence pack in $outputDir"
