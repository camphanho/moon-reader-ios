# ✅ Task 3.4: Statistics & Calendar - COMPLETED

## 📋 Task Summary
Theo dõi thói quen đọc và hiển thị thống kê + lịch đọc trong Settings.

## ✅ Completed Steps

### 1. Statistics Store
- `useStatisticsStore` (Zustand + persist)
  - `loadStatistics(book)` tải từ WatermelonDB qua `db.getStatisticsByBook`
  - `logReadingSession(book, duration, words)` cập nhật thống kê và gọi `db.addStatistics`
  - `dailyLog`, `totalTime`, `totalWords`, `getWeekData()`

### 2. Reader Integration
- `readerStore` cập nhật:
  - Lưu `sessionStart` mỗi khi load sách và khi chuyển trang
  - `setPage` log session hiện tại trước khi đổi trang
  - Cleanup effect trong `ReadingView` ghi nhận thời gian khi màn hình unmount
  - Mỗi lần mở sách mới → `statisticsStore.loadStatistics`

### 3. UI Components
- `ReadingStatisticsView`: cards tổng thời gian đọc, tốc độ trung bình, biểu đồ 7 ngày
- `ReadingCalendarView`: lưới 30 ngày với intensity màu
- Settings screen bổ sung:
  - Section “Thống kê đọc” bao gồm 2 component trên

## 🧪 Tests
- `npx tsc --noEmit`
- Manual logic (code-level): page change/unmount triggers logging, Settings hiển thị dữ liệu

## 📊 Acceptance Criteria
- ✅ Tracking thời gian & số chữ đọc
- ✅ Biểu đồ tuần + lịch 30 ngày
- ✅ Hiển thị trong Settings, tự động cập nhật theo sách hiện tại

## 🎯 Next Steps
- Task 3.5: TTS integration

---

**Status**: ✅ COMPLETED  
**Time Spent**: ~1 giờ  
**Date**: 2025-11-17

