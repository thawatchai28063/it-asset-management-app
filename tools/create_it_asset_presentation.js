const fs = require('fs');
const path = require('path');
const PptxGenJS = require('pptxgenjs');

const root = path.resolve(__dirname, '..');
const outDir = path.join(root, 'presentations');
const appDir = path.join(root, 'it_asset_management_app');
const iconPath = path.join(appDir, 'web', 'icons', 'Icon-512.png');
const outPath = path.join(outDir, 'IT_Asset_Management_App_Presentation.pptx');

fs.mkdirSync(outDir, { recursive: true });

const pptx = new PptxGenJS();
pptx.layout = 'LAYOUT_WIDE';
pptx.author = 'Codex';
pptx.company = 'IT Asset Management';
pptx.subject = 'Mobile app presentation';
pptx.title = 'IT Asset Management App';
pptx.lang = 'th-TH';
pptx.theme = {
  headFontFace: 'Leelawadee UI',
  bodyFontFace: 'Leelawadee UI',
  lang: 'th-TH',
};
pptx.defineLayout({ name: 'WIDE', width: 13.333, height: 7.5 });
pptx.layout = 'WIDE';

const C = {
  ink: '111827',
  muted: '6B7280',
  blue: '1D4ED8',
  blue2: '0EA5E9',
  indigo: '3730A3',
  teal: '14B8A6',
  green: '10B981',
  red: 'EF4444',
  orange: 'F97316',
  purple: '7C3AED',
  bg: 'F8FAFC',
  panel: 'FFFFFF',
  line: 'D8E2F0',
};

function addBg(slide, dark = false) {
  slide.background = { color: dark ? '0F172A' : C.bg };
  if (!dark) {
    slide.addShape(pptx.ShapeType.rect, {
      x: 0, y: 0, w: 13.333, h: 0.16,
      fill: { color: C.blue }, line: { color: C.blue },
    });
  }
}

function text(slide, value, x, y, w, h, opts = {}) {
  slide.addText(value, {
    x, y, w, h,
    margin: 0.05,
    breakLine: false,
    fit: 'shrink',
    fontFace: 'Leelawadee UI',
    color: opts.color || C.ink,
    fontSize: opts.size || 16,
    bold: opts.bold || false,
    align: opts.align || 'left',
    valign: opts.valign || 'mid',
    ...opts,
  });
}

function title(slide, kicker, claim, dark = false) {
  text(slide, kicker.toUpperCase(), 0.55, 0.34, 3.0, 0.28, {
    size: 8.5, bold: true, color: dark ? '93C5FD' : C.blue, charSpace: 1.5,
  });
  text(slide, claim, 0.55, 0.66, 8.7, 0.78, {
    size: 24, bold: true, color: dark ? 'F8FAFC' : C.ink,
  });
}

function footer(slide, n, dark = false) {
  text(slide, 'IT Asset Management App', 0.55, 7.08, 4.0, 0.22, {
    size: 8.5, color: dark ? '94A3B8' : C.muted,
  });
  text(slide, String(n).padStart(2, '0'), 12.25, 7.06, 0.55, 0.25, {
    size: 9, bold: true, align: 'right', color: dark ? 'CBD5E1' : C.muted,
  });
}

function card(slide, x, y, w, h, color = C.panel) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h,
    rectRadius: 0.08,
    fill: { color },
    line: { color: C.line, transparency: 15 },
    shadow: { type: 'outer', color: 'B8C2D6', opacity: 0.14, blur: 1, angle: 45, distance: 1 },
  });
}

function pill(slide, label, x, y, w, color) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h: 0.33,
    rectRadius: 0.08,
    fill: { color, transparency: 10 },
    line: { color, transparency: 50 },
  });
  text(slide, label, x + 0.1, y + 0.06, w - 0.2, 0.16, {
    size: 8.5, bold: true, color,
    align: 'center',
  });
}

function bulletList(slide, items, x, y, w, opts = {}) {
  const color = opts.color || C.ink;
  items.forEach((item, i) => {
    const yy = y + i * (opts.gap || 0.53);
    slide.addShape(pptx.ShapeType.ellipse, {
      x, y: yy + 0.09, w: 0.10, h: 0.10,
      fill: { color: opts.dot || C.blue }, line: { color: opts.dot || C.blue },
    });
    text(slide, item, x + 0.22, yy, w - 0.22, 0.34, {
      size: opts.size || 13.5, color,
    });
  });
}

function phone(slide, x, y, w, h, screenTitle, lines, accent = C.blue) {
  slide.addShape(pptx.ShapeType.roundRect, {
    x, y, w, h,
    rectRadius: 0.1,
    fill: { color: '111827' },
    line: { color: '1F2937' },
    shadow: { type: 'outer', color: '64748B', opacity: 0.25, blur: 2, angle: 45, distance: 2 },
  });
  slide.addShape(pptx.ShapeType.roundRect, {
    x: x + 0.16, y: y + 0.28, w: w - 0.32, h: h - 0.52,
    rectRadius: 0.08,
    fill: { color: 'FFFFFF' }, line: { color: 'FFFFFF' },
  });
  slide.addShape(pptx.ShapeType.roundRect, {
    x: x + 0.62, y: y + 0.09, w: w - 1.24, h: 0.09,
    rectRadius: 0.03,
    fill: { color: '374151' }, line: { color: '374151' },
  });
  text(slide, screenTitle, x + 0.34, y + 0.46, w - 0.68, 0.28, {
    size: 11, bold: true, color: C.ink,
  });
  lines.forEach((line, i) => {
    const yy = y + 0.94 + i * 0.46;
    slide.addShape(pptx.ShapeType.roundRect, {
      x: x + 0.34, y: yy, w: w - 0.68, h: 0.32,
      rectRadius: 0.05,
      fill: { color: i === 0 ? accent : 'EEF2FF', transparency: i === 0 ? 5 : 0 },
      line: { color: i === 0 ? accent : 'E0E7FF' },
    });
    text(slide, line, x + 0.47, yy + 0.08, w - 0.94, 0.12, {
      size: 7.4, bold: i === 0, color: i === 0 ? 'FFFFFF' : C.ink,
    });
  });
}

function iconCircle(slide, label, x, y, color) {
  slide.addShape(pptx.ShapeType.ellipse, {
    x, y, w: 0.58, h: 0.58,
    fill: { color, transparency: 6 },
    line: { color, transparency: 45 },
  });
  text(slide, label, x + 0.06, y + 0.15, 0.46, 0.18, {
    size: 9.5, bold: true, color, align: 'center',
  });
}

function cover() {
  const s = pptx.addSlide();
  addBg(s, true);
  s.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 7.5, fill: { color: '0F172A' }, line: { color: '0F172A' } });
  s.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: 13.333, h: 7.5, fill: { color: '1D4ED8', transparency: 82 }, line: { color: '1D4ED8', transparency: 100 } });
  if (fs.existsSync(iconPath)) s.addImage({ path: iconPath, x: 9.25, y: 1.0, w: 2.7, h: 2.7 });
  text(s, 'MOBILE APPLICATION', 0.72, 0.75, 3.2, 0.28, { size: 9, bold: true, color: '93C5FD', charSpace: 2 });
  text(s, 'IT Asset\nManagement App', 0.72, 1.22, 6.8, 1.55, { size: 35, bold: true, color: 'FFFFFF', breakLine: true });
  text(s, 'แอพมือถือสำหรับจัดการอุปกรณ์ IT พร้อมระบบ Login, Dashboard, CRUD Asset และ Maintenance Log', 0.75, 3.05, 7.8, 0.55, { size: 16, color: 'DBEAFE' });
  ['Flutter', 'PHP REST API', 'MySQL', 'XAMPP', 'JSON'].forEach((p, i) => pill(s, p, 0.75 + i * 1.35, 4.05, 1.15, ['60A5FA', '14B8A6', 'F97316', 'A78BFA', '22C55E'][i]));
  phone(s, 8.65, 3.98, 2.45, 2.8, 'Dashboard', ['Total assets 10', 'Available 4', 'In use 3', 'Repair 2'], C.blue);
  footer(s, 1, true);
}

function goals() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Project goals', 'ระบบเดียวสำหรับติดตามทรัพย์สิน IT ตั้งแต่รับเข้า ใช้งาน ซ่อม และปลดระวาง');
  bulletList(s, [
    'จัดเก็บข้อมูลอุปกรณ์ IT ให้ค้นหาและตามของได้รวดเร็ว',
    'ลดข้อมูลผิดพลาดด้วย dropdown, validation และ alert',
    'ติดตามสถานะอุปกรณ์: available, in_use, repair, retired',
    'ใช้ IT Tag เช่น IT250075 เพื่ออ้างอิงของจริงในหน้างาน',
  ], 0.75, 1.78, 6.0);
  const steps = [['รับอุปกรณ์', C.blue], ['ติด IT Tag', C.teal], ['มอบหมายแผนก', C.purple], ['ซ่อม/บันทึก', C.orange]];
  steps.forEach(([label, color], i) => {
    const x = 7.0 + i * 1.42;
    card(s, x, 2.3, 1.05, 1.45);
    iconCircle(s, String(i + 1), x + 0.24, 2.55, color);
    text(s, label, x + 0.1, 3.28, 0.85, 0.25, { size: 9.3, bold: true, align: 'center' });
    if (i < steps.length - 1) {
      s.addShape(pptx.ShapeType.chevron, { x: x + 1.08, y: 2.85, w: 0.26, h: 0.26, fill: { color: C.line }, line: { color: C.line } });
    }
  });
  phone(s, 8.25, 4.25, 2.2, 2.45, 'IT Tag', ['IT250075', 'FE Line 4', 'Department: IT'], C.teal);
  footer(s, 2);
}

function architecture() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'System architecture', 'Flutter เชื่อม PHP RESTful API และ MySQL ผ่าน JSON');
  const boxes = [
    ['Flutter Mobile App', 'Login, Dashboard, Asset CRUD', C.blue],
    ['PHP RESTful API', 'PDO, CORS, JSON Response', C.teal],
    ['MySQL Database', 'users, assets, maintenance_logs', C.orange],
  ];
  boxes.forEach(([h, sub, color], i) => {
    const x = 0.82 + i * 4.05;
    card(s, x, 2.35, 3.25, 1.55);
    iconCircle(s, i === 0 ? 'APP' : i === 1 ? 'API' : 'DB', x + 0.28, 2.62, color);
    text(s, h, x + 1.05, 2.58, 1.95, 0.25, { size: 13, bold: true });
    text(s, sub, x + 1.05, 2.95, 1.95, 0.36, { size: 10.5, color: C.muted });
    if (i < 2) s.addShape(pptx.ShapeType.chevron, { x: x + 3.48, y: 2.94, w: 0.32, h: 0.32, fill: { color: C.blue2 }, line: { color: C.blue2 } });
  });
  card(s, 1.2, 4.68, 10.9, 0.9, 'EFF6FF');
  text(s, 'API Example', 1.5, 4.92, 1.25, 0.2, { size: 10, bold: true, color: C.blue });
  text(s, 'GET /api/assets/index.php   |   POST /api/assets/create.php   |   GET /api/maintenance/index.php?asset_id=1', 2.65, 4.9, 8.9, 0.22, { size: 10.5, color: C.ink });
  footer(s, 3);
}

function auth() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Authentication', 'Register, Login และ Logout มี alert ชัดเจนทั้งสำเร็จและผิดพลาด');
  phone(s, 0.9, 1.75, 2.25, 3.6, 'Login', ['Email', 'Password', 'Login'], C.blue);
  phone(s, 3.55, 1.75, 2.25, 3.6, 'Register', ['Name', 'Email', 'Password', 'Create account'], C.teal);
  card(s, 6.65, 2.0, 2.45, 1.2, 'ECFDF5');
  iconCircle(s, 'OK', 6.95, 2.28, C.green);
  text(s, 'Success alert', 7.65, 2.3, 1.1, 0.25, { size: 12, bold: true, color: C.green });
  text(s, 'Login / Save สำเร็จ', 7.65, 2.66, 1.2, 0.2, { size: 9, color: C.muted });
  card(s, 9.25, 2.0, 2.45, 1.2, 'FEF2F2');
  iconCircle(s, 'X', 9.55, 2.28, C.red);
  text(s, 'Error alert', 10.25, 2.3, 1.1, 0.25, { size: 12, bold: true, color: C.red });
  text(s, 'ข้อมูลผิดพลาด/บันทึกไม่สำเร็จ', 10.25, 2.66, 1.15, 0.32, { size: 8.5, color: C.muted });
  card(s, 7.3, 4.08, 3.65, 0.98, 'FFF1F2');
  text(s, 'Logout button', 7.65, 4.28, 1.5, 0.22, { size: 12, bold: true, color: C.red });
  text(s, 'ปุ่มออกจากระบบเป็นสีแดง พร้อม confirm dialog ก่อนออก', 7.65, 4.62, 2.75, 0.22, { size: 9.5, color: C.ink });
  footer(s, 4);
}

function dashboard() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Dashboard overview', 'ผู้ใช้เห็นภาพรวมอุปกรณ์ทั้งหมดและเจาะดูตามประเภทหรือแผนกได้ทันที');
  phone(s, 0.9, 1.55, 2.45, 4.65, 'Dashboard', ['Total assets 10', 'Available 4', 'In use 3', 'Repair 2', 'Retired 1', 'View by department'], C.indigo);
  const metrics = [['Total', '10', C.blue], ['Available', '4', C.green], ['In use', '3', C.blue2], ['Repair', '2', C.orange], ['Retired', '1', C.muted]];
  metrics.forEach(([label, val, color], i) => {
    const x = 4.05 + (i % 3) * 2.55;
    const y = 1.9 + Math.floor(i / 3) * 1.35;
    card(s, x, y, 2.1, 0.95);
    text(s, val, x + 0.18, y + 0.17, 0.7, 0.3, { size: 20, bold: true, color });
    text(s, label, x + 0.18, y + 0.58, 1.3, 0.18, { size: 9.5, color: C.muted });
  });
  bulletList(s, ['Pull to refresh', 'View by asset type', 'View by department'], 4.2, 5.0, 5.2, { dot: C.indigo });
  footer(s, 5);
}

function assetList() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Asset list & filters', 'Card UI ทำให้ค้นหา กรอง และเปิดรายละเอียดอุปกรณ์ได้เร็ว');
  phone(s, 0.85, 1.45, 2.65, 4.85, 'Assets', ['Search assets', 'Department: IT', 'Laptop - SN001', 'IT Tag: IT250075', 'Printer - SN002'], C.blue);
  card(s, 4.05, 1.75, 7.85, 1.1);
  text(s, 'Search', 4.35, 2.05, 0.8, 0.22, { size: 12, bold: true, color: C.blue });
  text(s, 'ค้นหาจากชื่ออุปกรณ์, serial number, IT tag, department และข้อมูลสำคัญ', 5.15, 2.05, 5.9, 0.22, { size: 12 });
  card(s, 4.05, 3.18, 3.55, 1.25, 'EEF2FF');
  text(s, 'Department dropdown', 4.35, 3.45, 2.0, 0.22, { size: 12, bold: true, color: C.indigo });
  text(s, 'เลือกดูเฉพาะแผนกได้ เช่น IT, QA, Production', 4.35, 3.84, 2.55, 0.28, { size: 10 });
  card(s, 8.0, 3.18, 3.55, 1.25, 'ECFEFF');
  text(s, 'Asset type filter', 8.3, 3.45, 2.0, 0.22, { size: 12, bold: true, color: C.teal });
  text(s, 'ดูเฉพาะ Laptop, Printer, Network หรือประเภทอื่น ๆ', 8.3, 3.84, 2.6, 0.28, { size: 10 });
  footer(s, 6);
}

function detailTag() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Asset detail & IT Tag', 'รายละเอียดอุปกรณ์เชื่อมงานเอกสาร หน้างาน และประวัติซ่อมไว้ในจุดเดียว');
  phone(s, 0.85, 1.45, 2.65, 4.85, 'Asset Detail', ['Laptop Dell', 'IT Tag: IT250075', 'Serial: SN-2026-001', 'Department: IT', 'Location: FE Line 4'], C.teal);
  card(s, 4.25, 1.72, 3.0, 3.0, 'ECFEFF');
  text(s, 'IT Tag', 4.55, 2.0, 1.2, 0.26, { size: 16, bold: true, color: C.teal });
  text(s, 'IT250075', 4.55, 2.52, 2.1, 0.4, { size: 25, bold: true, color: C.ink });
  text(s, 'แสดงใต้ serial บน card เพื่อช่วยตามของจริงได้ง่าย', 4.55, 3.25, 2.25, 0.48, { size: 11, color: C.muted });
  card(s, 7.85, 1.72, 3.55, 3.0);
  bulletList(s, ['Type / Serial', 'IP address', 'Department', 'Assigned user', 'Location / Position', 'Purchase date'], 8.18, 2.05, 2.6, { size: 11.2, gap: 0.38, dot: C.blue });
  footer(s, 7);
}

function assetForm() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Add & edit asset form', 'ฟอร์มถูกจัดเป็นหมวดชัดเจน พร้อม dropdown และ date picker ลดการกรอกผิด');
  phone(s, 0.82, 1.42, 2.65, 4.9, 'New IT asset', ['Asset info', 'Asset type ▼', 'IT Tag', 'Assignment', 'Department ▼', 'Purchase date 📅'], C.purple);
  const groups = [
    ['Asset info', 'asset_name, asset_type, IT tag, serial, IP', C.blue],
    ['Assignment', 'department, status, assigned_user, position', C.purple],
    ['Dates & notes', 'purchase_date ผ่านปฏิทิน และ note', C.orange],
  ];
  groups.forEach(([h, sub, color], i) => {
    card(s, 4.25, 1.7 + i * 1.18, 6.6, 0.85);
    iconCircle(s, String(i + 1), 4.55, 1.84 + i * 1.18, color);
    text(s, h, 5.28, 1.84 + i * 1.18, 1.6, 0.2, { size: 13, bold: true, color });
    text(s, sub, 5.28, 2.15 + i * 1.18, 4.8, 0.18, { size: 9.5, color: C.muted });
  });
  card(s, 4.25, 5.42, 6.6, 0.75, 'EEF2FF');
  text(s, 'รองรับอุปกรณ์ใหม่', 4.55, 5.62, 1.8, 0.2, { size: 12, bold: true, color: C.indigo });
  text(s, 'Asset type มีตัวเลือก Other / Add new type เช่น CCTV, UPS, Barcode Scanner', 6.1, 5.62, 4.1, 0.2, { size: 9.7 });
  footer(s, 8);
}

function crud() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'CRUD actions', 'ทุก action ผ่าน REST API และมี alert แจ้งผลให้ผู้ใช้ทันที');
  const actions = [
    ['Create', 'POST create.php', C.green],
    ['Read', 'GET index/show.php', C.blue],
    ['Update', 'POST update.php', C.orange],
    ['Delete', 'POST delete.php', C.red],
  ];
  actions.forEach(([h, sub, color], i) => {
    const x = 0.9 + i * 3.05;
    card(s, x, 2.05, 2.45, 2.0);
    iconCircle(s, h[0], x + 0.92, 2.34, color);
    text(s, h, x + 0.25, 3.1, 1.95, 0.24, { size: 15, bold: true, align: 'center', color });
    text(s, sub, x + 0.25, 3.5, 1.95, 0.2, { size: 9.5, align: 'center', color: C.muted });
  });
  card(s, 2.05, 5.0, 4.1, 0.8, 'ECFDF5');
  text(s, 'Success', 2.35, 5.2, 1.0, 0.22, { size: 13, bold: true, color: C.green });
  text(s, 'บันทึก/แก้ไข/ลบ สำเร็จ', 3.3, 5.21, 2.2, 0.2, { size: 10.5 });
  card(s, 7.15, 5.0, 4.1, 0.8, 'FEF2F2');
  text(s, 'Error', 7.45, 5.2, 1.0, 0.22, { size: 13, bold: true, color: C.red });
  text(s, 'แสดงข้อความผิดพลาดสีแดง', 8.18, 5.21, 2.2, 0.2, { size: 10.5 });
  footer(s, 9);
}

function maintenance() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Maintenance log', 'ประวัติซ่อมผูกกับอุปกรณ์แต่ละชิ้น และเปิดได้จาก Asset Card หรือ Asset Detail');
  phone(s, 0.85, 1.45, 2.65, 4.85, 'Maintenance', ['Problem', 'Solution', 'Repair by', 'Repair date 📅', 'Status ▼'], C.orange);
  card(s, 4.0, 1.8, 7.4, 1.08);
  text(s, 'ข้อมูลที่จัดเก็บ', 4.35, 2.02, 1.5, 0.22, { size: 13, bold: true, color: C.orange });
  text(s, 'problem, solution, repair_by, repair_date, status และ created_at', 5.78, 2.02, 4.7, 0.22, { size: 11 });
  const paths = [['Asset Card', 'ปุ่มไอคอนซ่อมสีส้ม'], ['Asset Detail', 'ปุ่ม Maintenance log'], ['History Screen', 'เพิ่ม แก้ไข ลบ ประวัติซ่อม']];
  paths.forEach(([h, sub], i) => {
    card(s, 4.0 + i * 2.55, 3.45, 2.15, 1.15, i === 2 ? 'FFF7ED' : C.panel);
    text(s, h, 4.22 + i * 2.55, 3.72, 1.68, 0.2, { size: 12, bold: true, color: i === 2 ? C.orange : C.ink, align: 'center' });
    text(s, sub, 4.2 + i * 2.55, 4.08, 1.7, 0.28, { size: 8.8, color: C.muted, align: 'center' });
  });
  footer(s, 10);
}

function databaseApi() {
  const s = pptx.addSlide();
  addBg(s); title(s, 'Database & REST API', 'โครงสร้างข้อมูลแยก users, assets และ maintenance_logs พร้อม prepared statements');
  const tables = [
    ['users', ['id', 'name', 'email', 'password', 'role'], C.blue],
    ['assets', ['asset_name', 'asset_type', 'it_tag', 'department', 'position'], C.teal],
    ['maintenance_logs', ['asset_id', 'problem', 'solution', 'repair_date', 'status'], C.orange],
  ];
  tables.forEach(([name, fields, color], i) => {
    const x = 0.9 + i * 4.05;
    card(s, x, 1.85, 3.25, 3.65);
    text(s, name, x + 0.3, 2.13, 2.45, 0.28, { size: 16, bold: true, color });
    fields.forEach((f, j) => text(s, f, x + 0.45, 2.7 + j * 0.42, 2.1, 0.16, { size: 10.5, color: C.ink }));
  });
  s.addShape(pptx.ShapeType.line, { x: 7.2, y: 3.0, w: 1.2, h: 0, line: { color: C.orange, width: 2, beginArrowType: 'none', endArrowType: 'triangle' } });
  text(s, 'asset_id', 7.38, 2.68, 0.75, 0.16, { size: 8.5, bold: true, color: C.orange, align: 'center' });
  footer(s, 11);
}

function benefits() {
  const s = pptx.addSlide();
  addBg(s, true);
  title(s, 'Benefits & next steps', 'ระบบพร้อมใช้งานวันนี้ และต่อยอดได้กับ workflow ของทีม IT', true);
  const benefits = [
    ['เร็วขึ้น', 'ค้นหาและตามอุปกรณ์ด้วย IT Tag'],
    ['แม่นยำขึ้น', 'ลดการพิมพ์ผิดด้วย dropdown และ validation'],
    ['ตรวจสอบง่าย', 'ดูสถานะ แผนก และประวัติซ่อมย้อนหลัง'],
    ['ขยายต่อได้', 'เพิ่มประเภทอุปกรณ์ใหม่ได้ทันที'],
  ];
  benefits.forEach(([h, sub], i) => {
    const x = 0.85 + (i % 2) * 5.95;
    const y = 1.82 + Math.floor(i / 2) * 1.35;
    s.addShape(pptx.ShapeType.roundRect, {
      x, y, w: 5.2, h: 0.95, rectRadius: 0.08,
      fill: { color: '1E293B' }, line: { color: '334155' },
    });
    text(s, h, x + 0.3, y + 0.18, 1.3, 0.22, { size: 15, bold: true, color: 'FFFFFF' });
    text(s, sub, x + 1.65, y + 0.22, 3.1, 0.2, { size: 10.5, color: 'CBD5E1' });
  });
  card(s, 1.2, 5.15, 10.9, 0.75, 'DBEAFE');
  text(s, 'Next steps: role permission, export Excel/PDF, barcode/QR scanner, database backup', 1.55, 5.38, 9.9, 0.2, { size: 12, bold: true, color: C.indigo, align: 'center' });
  footer(s, 12, true);
}

[
  cover, goals, architecture, auth, dashboard, assetList,
  detailTag, assetForm, crud, maintenance, databaseApi, benefits,
].forEach((fn) => fn());

pptx.writeFile({ fileName: outPath });
console.log(outPath);
