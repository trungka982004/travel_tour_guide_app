# Giao Diện Xem Phòng & Đặt Phòng

---

## 📍 FLOW NGƯỜI DÙNG (USER FLOW)

1. Trang Danh sách phòng → 2. Trang Chi tiết phòng → 3. Trang Đặt phòng → 4. Xác nhận thành công  
   (Search & Filter) → (Chọn ngày & số người) → (Điền thông tin & thanh toán) → (Hiển thị mã đơn)

---

## 🛏️ 1. UI: Trang Danh Sách Phòng (Room List View)

### 🔍 Bộ lọc (Filter)
[🔘 Loại phòng] [🔘 Số người] [🔘 Giá] [🔘 Có khuyến mãi]

---

### 📷 [Ảnh phòng – Carousel nhỏ]
**Deluxe Sea View Room**  
👥 2 người | 📏 35m² | 🌊 View biển  
💵 **1.200.000đ/đêm**  ~1.500.000đ~ (-20%)  
[📄 Xem chi tiết]   [🛏️ Đặt ngay]

---

### 📷 [Ảnh phòng – Carousel nhỏ]
**Family Villa**  
👥 4 người | 📏 60m² | 🛁 Bồn tắm | 🌳 Sân vườn riêng  
💵 **2.800.000đ/đêm**  
[📄 Xem chi tiết]   [🛏️ Đặt ngay]

---

## 🛋️ 2. UI: Trang Chi Tiết Phòng (Room Detail Page)

📷 [Ảnh phòng – Carousel lớn]

**🛏️ Deluxe Sea View Room**  
📏 35m² | 👥 2 người lớn + 1 trẻ em | 🌊 View biển  
🛁 Wifi, TV, Tủ lạnh mini, Điều hoà, Bồn tắm  
📌 Chính sách huỷ miễn phí trước 48h

---

### 📅 Ngày & Khách:
[🗓️ Check-in: ___ ]   [🗓️ Check-out: ___ ]  
[👤 Người lớn: 2] [👶 Trẻ em: 1]  
[🔎 Kiểm tra phòng còn trống]

💵 **Giá: 1.200.000đ / đêm**

[👉 Tiếp tục đặt phòng]

---

## 📦 3. UI: Đặt Phòng (Booking Page)

### 📝 Thông Tin Khách
👤 Họ tên: ____________  
📱 SĐT: ____________  
📧 Email: ____________  
📝 Ghi chú: ______________________

---

### 💳 Thanh Toán
[🔘 Trả tại Resort]  
[🔘 Trả Online: VNPay / ZaloPay / MoMo]  
🎟️ Mã giảm giá: ___________

---

### 🧾 Tóm tắt đơn hàng:
**Phòng:** Deluxe Sea View  
**Ngày:** 10/08 - 12/08  
**Khách:** 2 NL + 1 TE  
**Tổng:** **2.400.000đ** (2 đêm)

[✅ Xác nhận đặt phòng]

---

## ✅ 4. UI: Trang Xác Nhận Thành Công

🎉 **Đặt phòng thành công!**  
🧾 Mã đơn: `#RS123456789`  
📅 Thời gian: 10/08 - 12/08  
🏨 Phòng: Deluxe Sea View  
👥 Khách: 2 NL + 1 TE  
💵 Tổng tiền: 2.400.000đ

[🏠 Trang chủ]   [🗂️ Xem đơn đã đặt]

---

## 💡 UX Notes

- **Filter dễ dùng:** đơn giản, gợi ý lựa chọn nhanh (chip hoặc bottom sheet).
- **Ảnh đẹp là yếu tố bán hàng:** Carousel + Zoom + Tag “Hot”, “Sale”.
- **Thông tin phòng ngắn gọn + chi tiết rõ ràng:** chia cấp độ (trên thẻ + trong trang chi tiết).
- **CTA (Call-to-action) nổi bật:** “Đặt ngay” luôn dễ thấy.
- **Luồng đặt phòng tối giản:** ít bước, xác nhận rõ, hỗ trợ thanh toán tiện lợi.
- **Trạng thái động:** phòng còn trống, đã full, còn ít slot, tạo cảm giác cấp bách (UX trigger).
- **Tương thích mobile:** nút lớn, font dễ đọc, thao tác một tay.

---

