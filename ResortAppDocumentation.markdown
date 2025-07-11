# Resort App Documentation

## Overview
**Date and Time**: 01:17 PM +07, Friday, July 11, 2025  
This document details the design and functionality of a mobile application for Carmelina Beach Resort, enabling guests to explore and book services (rooms, dining, activities, excursions) and manage settings. The app is **minimalist**, **intuitive**, and **user-friendly**, with a consistent design:
- **Colors**: #1976D2 (blue), #FFFFFF (white), #F5F7FA (light gray).
- **Fonts**: 16px bold (titles), 12px (descriptions).
- **Effects**: Fade-in (lists), scale (buttons), pulse (notifications).
- **Accessibility**: 4.5:1 contrast, ≥48x48px buttons.
- **Data**: Dynamic via server APIs (e.g., GET `/services`, POST `/bookings`).

Each screen includes a detailed **User Flow** (step-by-step actions, error handling, success scenarios), **Functionality** (core features and data handling), and **UI Description** (components, layout, design).

## 1. Home Screen

### How It Works
- **Purpose**: Entry point for navigation, showcasing services and personalized recommendations.
- **Functionality**:
  - **Navigation**: Tap grid items to access Booking, Restaurant, Activities, Excursions, Settings, or Services Screens.
  - **Search**: Suggests services/activities (e.g., “rooms”, “tour”) and redirects to relevant screens.
  - **Recommendations**: Displays tailored suggestions based on user history or resort promotions (API: GET `/recommendations`).
  - **Support**: Quick Support opens chat or hotline.
- **User Flow**:
  1. **Enter Screen**: App loads, displaying Header, Personalized Recommendation, Service Grid, and Quick Support. User sees a tooltip (first-time only): “Chọn dịch vụ từ lưới hoặc tìm kiếm”.
  2. **View Recommendations**:
     - Browse carousel (e.g., “Tour kayak” 🎉, “Blue Sea Restaurant” 🍽️).
     - Tap “Đặt ngay” to navigate to relevant screen (e.g., Booking Screen for tours).
     - **Error Handling**: If API fails (GET `/recommendations`), display fallback message: “Không có gợi ý, vui lòng thử lại” with retry button.
  3. **Navigate via Service Grid**:
     - Tap grid item (e.g., “Cài đặt” ⚙️) to go to corresponding screen.
     - **Error Handling**: If screen fails to load, show toast: “Lỗi kết nối, thử lại”.
  4. **Search**:
     - Enter query (e.g., “tour”), see suggestions (e.g., “Tour kayak”, “Tour Vũng Tàu”).
     - Select suggestion to navigate (e.g., to Excursions Screen).
     - **Error Handling**: If no results, display “Không tìm thấy, vui lòng thử lại”.
  5. **Contact Support**:
     - Tap Quick Support (💬/📞) to open chat or call hotline.
     - **Error Handling**: If chat fails, show “Lỗi kết nối hỗ trợ” with retry.
  6. **Exit**: Tap profile icon (👤) to view account or log out, redirecting to login screen.
- **Data Handling**:
  - Loads grid and recommendations (GET `/services`, GET `/recommendations`).
  - Search queries processed locally or via API (GET `/search`).

### UI Description
- **Components**:
  - **Header Section**:
    - Title: “Resort App” (16px, bold, #1976D2, centered).
    - Profile icon (👤, 24px, top-right).
    - Search bar (80% width, 8px radius, placeholder “Tìm dịch vụ...”, 🔍).
  - **Personalized Recommendation**:
    - Carousel (120x80px images, #F5F7FA, 8px radius).
    - Example: “Tour kayak” (🎉, 14px, #1976D2), “Đặt ngay” (#1976D2).
  - **Service Grid**:
    - 2–3 columns (tablet), 1 column (mobile), cards (8px radius, #F5F7FA).
    - Items: Rooms (🏠), Restaurant (🍽️), Activities (🎉), Excursions (🗺️), Settings (⚙️), Services (🚗).
    - Labels: 14px, bold, #1976D2; icons: 24px.
  - **Quick Support**: Floating button (bottom-right, #1976D2, 💬/📞).
- **Layout**:
  ```
  ----------------------------------------
  | [👤] Resort App                     |
  | [🔍 Tìm dịch vụ...]                 |
  ----------------------------------------
  | [Personalized Recommendation]        |
  | [Tour] [Dining] [Excursion] >       |
  ----------------------------------------
  | [Service Grid]                      |
  | [🏠] [🍽️] [🎉]                     |
  | [🗺️] [⚙️] [🚗]                     |
  ----------------------------------------
  | [💬] (bottom-right)                 |
  ----------------------------------------
  ```
- **Design**:
  - Colors: #1976D2, #F5F7FA, #FFFFFF.
  - Effects: Fade-in (carousel), scale (grid buttons).
  - Responsive: Grid adapts to screen size.
  - Accessibility: 4.5:1 contrast, ≥48x48px buttons.

## 2. Booking Screen

### How It Works
- **Purpose**: Books rooms and services (e.g., dining, sports).
- **Functionality**:
  - **Selection**: Choose rooms/services, specify dates/times.
  - **Invoice**: Add/edit/delete items in Booking Invoice.
  - **Confirmation**: Save bookings to server or clear.
- **User Flow**:
  1. **Enter Screen**: Loads Header, Service Selection, Booking Invoice (empty, dimmed), Quick Support. Tooltip (first-time): “Chọn phòng/dịch vụ và thêm vào hóa đơn”.
  2. **Select Service**:
     - Choose from dropdown (e.g., “Suite Ocean View” 🏠, “Tennis Court” 🎾).
     - Select dates (calendar, e.g., 12/07/2025–14/07/2025) or time (dropdown, e.g., 14:00).
     - **Error Handling**: If no selection, “Tiếp tục” dimmed; if unavailable, show “Hết chỗ, chọn ngày khác”.
  3. **Add to Invoice**:
     - Tap “Tiếp tục”, item appears in Booking Invoice (e.g., “[🏠] Suite Ocean View, 12/07/2025–14/07/2025”).
     - **Error Handling**: If API fails (POST `/temp-booking`), show “Lỗi thêm mục, thử lại”.
  4. **Manage Invoice**:
     - Tap ✏️ to edit (reopen form with pre-filled data).
     - Tap 🗑️ to delete item, confirm via prompt: “Xóa mục này?”.
     - **Error Handling**: If edit fails, show “Lỗi tải dữ liệu, thử lại”.
  5. **Confirm or Cancel**:
     - Tap “Xác nhận” to send to server (POST `/bookings`), show success: “Đặt thành công” with summary.
     - Tap “Hủy” to clear invoice, confirm prompt: “Hủy tất cả?”.
     - **Error Handling**: If POST fails, show “Lỗi đặt chỗ, thử lại” with retry.
  6. **Post-Confirmation**:
     - Success screen shows summary (e.g., “[🏠] Suite Ocean View, 12/07/2025–14/07/2025”), “Quay lại Trang chủ” button.
     - Redirect to Home Screen.
  7. **Support**: Tap Quick Support for booking issues (e.g., unavailable slots).
- **Data Handling**:
  - Loads services (GET `/services`), stores in state.
  - Sends bookings (POST `/bookings`), saves history (GET `/booking-history`).

### UI Description
- **Components**:
  - **Header Section**:
    - Title: “Đặt phòng/Dịch vụ” (16px, bold, #1976D2).
    - Back button (←, 24px).
  - **Service Selection**:
    - Dropdown (80% width, 8px radius, placeholder “Chọn phòng/dịch vụ”).
    - Calendar/time slots.
    - “Tiếp tục” (#1976D2, dimmed until selection).
  - **Booking Invoice**:
    - Title: “Hóa đơn của bạn” (16px, bold, #1976D2).
    - Cards (8px radius, #F5F7FA): e.g., “[🏠] Suite Ocean View, 12/07/2025–14/07/2025”.
    - Edit (✏️), delete (🗑️), “X mục đã chọn” (12px, #757575).
    - Buttons: “Xác nhận” (#1976D2), “Hủy” (#757575).
  - **Quick Support**: Floating button (💬/📞).
- **Layout**:
  ```
  ----------------------------------------
  | ← | Đặt phòng/Dịch vụ               |
  ----------------------------------------
  | [Service Selection]                 |
  | [Dropdown: Chọn phòng/dịch vụ]      |
  | [Calendar/Time Slots]               |
  | [Tiếp tục]                          |
  ----------------------------------------
  | [Booking Invoice]                   |
  | [🏠] Suite Ocean View               |
  | 12/07/2025–14/07/2025 [✏️][🗑️]     |
  | 1 mục đã chọn                       |
  | [Xác nhận] [Hủy]                    |
  ----------------------------------------
  | [💬] (bottom-right)                 |
  ----------------------------------------
  ```
- **Design**:
  - Colors: #1976D2, #F5F7FA, #757575, #4CAF50 (available), #F44336 (unavailable).
  - Effects: Fade-in (cards), scale (buttons).
  - Responsive: Scrollable invoice.
  - Accessibility: High contrast, large buttons.

## 3. Activities Screen

### How It Works
- **Purpose**: Showcases resort activities/events (e.g., kayak, yoga, BBQ).
- **Functionality**:
  - **Browsing**: Filter/sort by type (sports, culture, relaxation) or time.
  - **Details**: View descriptions or book via Booking Screen.
  - **Notifications**: Highlight urgent events.
- **User Flow**:
  1. **Enter Screen**: Loads Header, Event Notification, Filter & Sort Bar, Activity List, Quick Support. Tooltip (first-time): “Lọc hoạt động hoặc đặt ngay”.
  2. **Browse Activities**:
     - Use Filter & Sort Bar (e.g., “Thể thao” 🎾, “Gần nhất”).
     - View Activity List (e.g., “Tour kayak, 12/07/2025, 09:00, còn”).
     - **Error Handling**: If API fails (GET `/activities`), show “Không tải được hoạt động, thử lại”.
  3. **View Details**:
     - Tap “Xem chi tiết” to open modal with full description (e.g., “Tour kayak: 2 giờ, bao gồm hướng dẫn”).
     - Close modal or tap “Đặt ngay” from modal.
     - **Error Handling**: If modal fails to load, show “Lỗi tải chi tiết”.
  4. **Book Activity**:
     - Tap “Đặt ngay” to navigate to Booking Screen with pre-filled activity (e.g., “Tour kayak, 12/07/2025, 09:00”).
     - **Error Handling**: If navigation fails, show “Lỗi chuyển hướng, thử lại”.
  5. **Event Notification**:
     - View highlighted event (e.g., “Tiệc BBQ, 19:00, 12/07/2025”).
     - Tap “Đặt ngay” to go to Booking Screen.
     - **Error Handling**: If event unavailable, show “Sự kiện đã hết chỗ”.
  6. **Support**: Tap Quick Support for activity queries (e.g., schedule clarification).
- **Data Handling**:
  - Loads activities (GET `/activities`), filters/sorts locally or via API.
  - Booking redirects to Booking Screen with pre-filled data.

### UI Description
- **Components**:
  - **Header Section**:
    - Title: “Hoạt động & Sự kiện” (16px, bold, #1976D2).
    - Back button (←, 24px).
    - Search bar (placeholder “Tìm hoạt động...”).
  - **Filter & Sort Bar**:
    - Filters: “Tất cả”, “Thể thao” (🎾), “Văn hóa” (🎭), “Thư giãn” (🧘).
    - Sort: “Gần nhất”, “Phổ biến” (dropdown, 12px).
  - **Event Notification**:
    - Card (full-width, 8px radius, #F5F7FA, #F44336 border).
    - Example: “Tiệc BBQ, 19:00, 12/07/2025”, “Đặt ngay” (#1976D2).
  - **Activity List**:
    - Cards (8px radius, #F5F7FA): e.g., “[🎉] Tour kayak, 12/07/2025, 09:00, còn”.
    - Buttons: “Xem chi tiết”, “Đặt ngay” (#1976D2).
  - **Quick Support**: Floating button (💬/📞).
- **Layout**:
  ```
  ----------------------------------------
  | ← | Hoạt động & Sự kiện            |
  | [🔍 Tìm hoạt động...]               |
  ----------------------------------------
  | [Event Notification]                |
  | [Tiệc BBQ, 19:00] [Đặt ngay]        |
  ----------------------------------------
  | [Filter & Sort Bar]                 |
  | [Tất cả] [Thể thao] [Văn hóa]       |
  | [Gần nhất ▼]                        |
  ----------------------------------------
  | [Activity List]                     |
  | [🎉] Tour kayak, 09:00, còn         |
  | [Xem chi tiết] [Đặt ngay]           |
  ----------------------------------------
  | [💬] (bottom-right)                 |
  ----------------------------------------
  ```
- **Design**:
  - Colors: #1976D2, #F5F7FA, #4CAF50, #F44336.
  - Effects: Fade-in (cards), pulse (notification), scale (buttons).
  - Responsive: Grid (tablet) or list (mobile).
  - Accessibility: High contrast, large buttons.

## 4. Restaurant Screen

### How It Works
- **Purpose**: Displays dining options, books tables/meals on-screen.
- **Functionality**:
  - **Browsing**: Filter/sort restaurants (seafood, buffet, café).
  - **Booking**: Select restaurant, time/people, add to Order Summary.
  - **Confirmation**: Save bookings or clear.
- **User Flow**:
  1. **Enter Screen**: Loads Header, Filter & Sort Bar, Restaurant List, Order Summary (empty, dimmed), Quick Support. Tooltip (first-time): “Chọn nhà hàng và đặt bàn”.
  2. **Browse Restaurants**:
     - Use Filter & Sort Bar (e.g., “Hải sản” 🦐, “Phổ biến”).
     - View Restaurant List (e.g., “Blue Sea Restaurant, 11:00-22:00, còn”).
     - **Error Handling**: If API fails (GET `/restaurants`), show “Không tải được nhà hàng, thử lại”.
  3. **View Menu**:
     - Tap “Xem thực đơn” to open modal with dishes (e.g., “Cá nướng, 150.000 VNĐ”).
     - Close modal or proceed to booking.
     - **Error Handling**: If menu fails to load, show “Lỗi tải thực đơn”.
  4. **Book Table**:
     - Tap “Đặt bàn” to open form:
       - Time (dropdown, e.g., 19:00).
       - People (dropdown, e.g., 2 people).
       - Location (e.g., indoor, outdoor).
     - Tap “Thêm vào đơn” to add to Order Summary.
     - **Error Handling**: If slot unavailable, show “Hết bàn, chọn giờ khác”.
  5. **Manage Order Summary**:
     - View added items (e.g., “[🍽️] Blue Sea, 12/07/2025, 19:00, 2 người”).
     - Tap ✏️ to edit (reopen form), 🗑️ to delete (prompt: “Xóa mục này?”).
     - **Error Handling**: If edit fails, show “Lỗi tải dữ liệu”.
  6. **Confirm or Cancel**:
     - Tap “Xác nhận” to send (POST `/restaurant-bookings`), show success: “Đặt bàn thành công”.
     - Tap “Hủy” to clear, prompt: “Hủy tất cả?”.
     - **Error Handling**: If POST fails, show “Lỗi đặt bàn, thử lại”.
  7. **Post-Confirmation**:
     - Success screen: e.g., “[🍽️] Blue Sea, 12/07/2025, 19:00, 2 người”, “Quay lại Trang chủ”.
     - Redirect to Home Screen.
  8. **Support**: Tap Quick Support for dining queries.
- **Data Handling**:
  - Loads restaurants (GET `/restaurants`), stores in state.
  - Sends bookings (POST `/restaurant-bookings`).

### UI Description
- **Components**:
  - **Header Section**:
    - Title: “Nhà hàng” (16px, bold, #1976D2).
    - Back button (←, 24px).
    - Search bar (placeholder “Tìm nhà hàng/món ăn...”).
  - **Filter & Sort Bar**:
    - Filters: “Tất cả”, “Hải sản” (🦐), “Buffet” (🍽️), “Cà phê” (☕).
    - Sort: “Gần nhất”, “Phổ biến”.
  - **Restaurant List**:
    - Cards (8px radius, #F5F7FA, 100x80px images): e.g., “[🦐] Blue Sea, 11:00-22:00, còn”.
    - Buttons: “Xem thực đơn”, “Đặt bàn” (#1976D2).
  - **Order Summary**:
    - Title: “Đơn đặt của bạn” (16px, bold, #1976D2).
    - Cards: e.g., “[🍽️] Blue Sea, 12/07/2025, 19:00, 2 người”.
    - Edit (✏️), delete (🗑️), “X mục đã chọn” (12px).
    - Buttons: “Xác nhận” (#1976D2), “Hủy” (#757575).
  - **Quick Support**: Floating button (💬/📞).
- **Layout**:
  ```
  ----------------------------------------
  | ← | Nhà hàng                       |
  | [🔍 Tìm nhà hàng/món ăn...]         |
  ----------------------------------------
  | [Filter & Sort Bar]                 |
  | [Tất cả] [Hải sản] [Buffet]         |
  | [Gần nhất ▼]                        |
  ----------------------------------------
  | [Restaurant List]                   |
  | [🦐] Blue Sea, 11:00-22:00, còn     |
  | [Xem thực đơn] [Đặt bàn]            |
  ----------------------------------------
  | [Order Summary]                     |
  | [🍽️] Blue Sea, 19:00, 2 người      |
  | [✏️][🗑️]                           |
  | 1 mục đã chọn                       |
  | [Xác nhận] [Hủy]                    |
  ----------------------------------------
  | [💬] (bottom-right)                 |
  ----------------------------------------
  ```
- **Design**:
  - Colors: #1976D2, #F5F7FA, #4CAF50, #F44336.
  - Effects: Fade-in (cards), scale (buttons).
  - Responsive: List or grid, scrollable.
  - Accessibility: High contrast, large buttons.

## 5. Services Screen

### How It Works
- **Purpose**: Offers services (e.g., transport, wheelchair, swimwear, guide, laundry, diving gear).
- **Functionality**:
  - **Browsing**: Filter/sort by type.
  - **Booking**: Select service, details, add to Order Summary.
  - **Confirmation**: Save bookings or clear.
- **User Flow**:
  1. **Enter Screen**: Loads Header, Filter & Sort Bar, Service List, Order Summary (empty, dimmed), Quick Support. Tooltip (first-time): “Chọn dịch vụ và thêm vào đơn”.
  2. **Browse Services**:
     - Use Filter & Sort Bar (e.g., “Đưa rước” 🚗, “Gần nhất”).
     - View Service List (e.g., “Đưa rước sân bay, 08:00-20:00, còn”).
     - **Error Handling**: If API fails (GET `/services`), show “Không tải được dịch vụ, thử lại”.
  3. **Add Service**:
     - Tap “Thêm vào đơn” to open form:
       - Details (dropdown, e.g., “Xe 4 chỗ”, “Bộ bơi nam”).
       - Date/time (calendar/dropdown, e.g., 12/07/2025, 08:00).
     - Tap “Thêm vào đơn” to add to Order Summary.
     - **Error Handling**: If unavailable, show “Dịch vụ hết, chọn khác”.
  4. **Manage Order Summary**:
     - View items (e.g., “[🚗] Đưa rước, 12/07/2025, 08:00, xe 4 chỗ”).
     - Tap ✏️ to edit, 🗑️ to delete (prompt: “Xóa mục này?”).
     - **Error Handling**: If edit fails, show “Lỗi tải dữ liệu”.
  5. **Confirm or Cancel**:
     - Tap “Xác nhận” to send (POST `/service-bookings`), show success: “Đặt thành công”.
     - Tap “Hủy” to clear, prompt: “Hủy tất cả?”.
     - **Error Handling**: If POST fails, show “Lỗi đặt dịch vụ, thử lại”.
  6. **Post-Confirmation**:
     - Success screen: e.g., “[🚗] Đưa rước, 12/07/2025, 08:00, xe 4 chỗ”, “Quay lại Trang chủ”.
     - Redirect to Home Screen.
  7. **Support**: Tap Quick Support for service queries.
- **Data Handling**:
  - Loads services (GET `/services`), stores in state.
  - Sends bookings (POST `/service-bookings`).

### UI Description
- **Components**:
  - **Header Section**:
    - Title: “Dịch vụ” (16px, bold, #1976D2).
    - Back button (←, 24px).
    - Search bar (placeholder “Tìm dịch vụ...”).
  - **Filter & Sort Bar**:
    - Filters: “Tất