$(document).ready(function () {
    // Khởi tạo Slick Slider cho Hero Banner (Tràn màn hình)
    $('.hero-banner-slider').slick({
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 4000,
        arrows: true, // Bật nút chuyển (Next/Prev)
        dots: true, // Bật dấu chấm ở dưới
        // Thiết kế lại giao diện nút Next/Prev
        prevArrow: '<button class="hero-arrow-btn position-absolute top-50 translate-middle-y shadow-sm" style="z-index: 10; left: 30px; width: 45px; height: 45px; border-radius: 50%;"><i class="fas fa-chevron-left"></i></button>',
        nextArrow: '<button class="hero-arrow-btn position-absolute top-50 translate-middle-y shadow-sm" style="z-index: 10; right: 30px; width: 45px; height: 45px; border-radius: 50%;"><i class="fas fa-chevron-right"></i></button>'
    });

    // 1. Khởi tạo Slick Slider cho Món ăn phổ biến
    $('.popular-food-slider').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 3000,
        arrows: true,
        prevArrow: $('.custom-prev'),
        nextArrow: $('.custom-next'),
        dots: false,
        responsive: [
            {breakpoint: 1200, settings: {slidesToShow: 3}}, // Dưới 1200px: Hiện 3 món
            {breakpoint: 992, settings: {slidesToShow: 2}}, // Dưới 992px (Tablet): Hiện 2 món
            {breakpoint: 576, settings: {slidesToShow: 1}}   // Dưới 576px (Mobile): Hiện 1 món
        ]
    });

    $('.testimonial-slider').slick({
        infinite: true, slidesToShow: 3, slidesToScroll: 1, autoplay: true, autoplaySpeed: 4000, arrows: false, dots: true,
        responsive: [{breakpoint: 1024, settings: {slidesToShow: 2}}, {breakpoint: 768, settings: {slidesToShow: 1}}]
    });

    // 2. Khởi tạo Slick Slider cho Thực đơn Best Seller (Phần bạn đang bị lỗi)
    const $menuSlider = $('.menu-slider').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 3000,
        arrows: true,
        prevArrow: $('.menu-prev'),
        nextArrow: $('.menu-next'),
        dots: false,
        responsive: [
            {breakpoint: 1200, settings: {slidesToShow: 3}}, // Dưới 1200px: Hiện 3 món
            {breakpoint: 992, settings: {slidesToShow: 2}}, // Dưới 992px (Tablet): Hiện 2 món
            {breakpoint: 576, settings: {slidesToShow: 1}}   // Dưới 576px (Mobile): Hiện 1 món
        ]
    });

//    Giỏ hàng
    $('#btn-plus').click(function () {
        let currentVal = parseInt($('#qty-input').val());
        if (!isNaN(currentVal)) {
            $('#qty-input').val(currentVal + 1);
        }
    });

    $('#btn-minus').click(function () {
        let currentVal = parseInt($('#qty-input').val());
        if (!isNaN(currentVal) && currentVal > 1) {
            $('#qty-input').val(currentVal - 1);
        }
    });

    // 2. Logic cho Món ăn kèm (Nhấn vào hàng để tăng, nhấn dấu trừ để giảm)
    $('.addable-item').click(function (e) {
        // Ngăn sự kiện khi người dùng click vào dấu (-) để xóa
        if ($(e.target).hasClass('remove-icon')) {
            return;
        }

        let qtySpan = $(this).find('.item-qty');
        let removeBtn = $(this).find('.remove-icon');
        let currentQty = parseInt(qtySpan.attr('data-qty') || 0);
        let maxQty = parseInt($(this).attr('data-max') || 99);

        // Tăng số lượng và hiển thị
        if (currentQty < maxQty) {
            currentQty++;
            qtySpan.attr('data-qty', currentQty).text(currentQty + 'x').fadeIn(150);
            removeBtn.fadeIn(150); // Hiện dấu trừ
        }
    });

    // 3. Logic cho nút Giảm/Xóa món ăn kèm
    $('.remove-icon').click(function (e) {
        e.stopPropagation(); // Không cho sự kiện click truyền lên dòng (tránh bị hiểu nhầm là click tăng)
        let parentItem = $(this).closest('.addable-item');
        let qtySpan = parentItem.find('.item-qty');
        let currentQty = parseInt(qtySpan.attr('data-qty') || 0);

        if (currentQty > 0) {
            currentQty--;
            qtySpan.attr('data-qty', currentQty);

            // Nếu giảm về 0 thì ẩn số x và ẩn nút (-)
            if (currentQty === 0) {
                qtySpan.fadeOut(150);
                $(this).fadeOut(150);
            } else {
                qtySpan.text(currentQty + 'x');
            }
        }
    });


});

document.addEventListener("DOMContentLoaded", function () {
    // --- NÚT BACK TO TOP ---
    const backTopBtn = document.querySelector("[data-back-top-btn]");
    if (backTopBtn) {
        const toggleBackTop = function () {
            backTopBtn.classList.toggle("active", window.scrollY >= 100);
        };

        // Lắng nghe sự kiện khi người dùng cuộn chuột
        window.addEventListener("scroll", toggleBackTop);

        // Gọi hàm ngay lập tức khi trang vừa load xong
        toggleBackTop();
    }

    // =========================================================
    // LỌC CHO TRANG THỰC ĐƠN (3 BỘ LỌC KẾT HỢP ĐỒNG THỜI)
    // =========================================================
    const menuGrid = document.getElementById('menu-grid');
    const paginationContainer = document.getElementById('pagination');

    if (menuGrid && paginationContainer) {
        const filterBtns = document.querySelectorAll('.filter-btn'); // Hàng bán chạy
        const checkboxes = document.querySelectorAll('.filter-box input[type="checkbox"]'); // Checkbox loại SP
        const menuItems = Array.from(document.querySelectorAll('.food-item')); // Danh sách món ăn

        const minPriceInput = document.getElementById('minPrice');
        const maxPriceInput = document.getElementById('maxPrice');
        const priceDisplay = document.getElementById('priceDisplay');
        const sliderTrack = document.getElementById('sliderTrack');

        const itemsPerPage = 9;
        let currentPage = 1;

        // Lưu trữ trạng thái của cả 3 bộ lọc
        let activeFilters = {
            sideCategory: 'all',
            checkboxes: [],
            price: {min: 0, max: 2000000}
        };

        function formatCurrency(value) {
            return new Intl.NumberFormat('vi-VN').format(value) + 'đ';
        }

        function extractPrice(item) {
            let clone = item.querySelector('.price').cloneNode(true);
            let del = clone.querySelector('del');
            if (del)
                clone.removeChild(del);
            return parseInt(clone.textContent.replace(/\D/g, ''));
        }

        // Cập nhật lại danh sách món ăn
        function updateView() {
            let filteredItems = menuItems.filter(item => {
                const category = item.getAttribute('data-category');
                const price = extractPrice(item);

                // Kiểm tra thỏa mãn cả 3 điều kiện
                const passSide = (activeFilters.sideCategory === 'all') || (category === activeFilters.sideCategory);
                const passCheck = (activeFilters.checkboxes.length === 0) || (activeFilters.checkboxes.includes(category));
                const passPrice = (price >= activeFilters.price.min && price <= activeFilters.price.max);

                return passSide && passCheck && passPrice;
            });

            const totalPages = Math.ceil(filteredItems.length / itemsPerPage);
            if (currentPage > totalPages && totalPages > 0)
                currentPage = totalPages;

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;

            menuItems.forEach(item => {
                item.classList.remove('show');
                item.style.display = 'none';
            });

            const itemsToShow = filteredItems.slice(startIndex, endIndex);
            itemsToShow.forEach(item => {
                item.style.display = 'block';
                setTimeout(() => item.classList.add('show'), 10);
            });

            renderPagination(totalPages);
        }

        // 1. Bắt sự kiện Click danh mục Hàng bán chạy
        filterBtns.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                // Bấm lại mục đang chọn -> Hủy chọn (Trạng thái ngầm định về 'all' nhưng không có nút nào sáng)
                if (this.classList.contains('active')) {
                    this.classList.remove('active');
                    activeFilters.sideCategory = 'all'; // Tự động lọc tất cả
                } else {
                    // Chọn mục mới
                    filterBtns.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    activeFilters.sideCategory = this.getAttribute('data-filter');
                }
                currentPage = 1;
                updateView();
            });
        });

        // 2. Bắt sự kiện Tick Checkbox
        checkboxes.forEach(cb => {
            cb.addEventListener('change', function () {
                activeFilters.checkboxes = Array.from(checkboxes).filter(i => i.checked).map(i => i.value);
                currentPage = 1;
                updateView();
            });
        });

        // 3. Bắt sự kiện Kéo Thanh Trượt Giá
        if (minPriceInput && maxPriceInput && priceDisplay && sliderTrack) {
            function updateSliderUIAndFilter(e) {
                let minVal = parseInt(minPriceInput.value);
                let maxVal = parseInt(maxPriceInput.value);
                const maxLimit = parseInt(minPriceInput.max);
                const gap = 0;

                if (maxVal - minVal < gap) {
                    if (e && e.target.id === 'minPrice') {
                        // Nếu đang kéo nút Min chạm vào nút Max -> Đẩy nút Min lùi lại
                        minPriceInput.value = maxVal - gap;
                        minVal = parseInt(minPriceInput.value);
                    } else if (e && e.target.id === 'maxPrice') {
                        // Nếu đang kéo nút Max chạm vào nút Min -> Đẩy nút Max tiến lên
                        maxPriceInput.value = minVal + gap;
                        maxVal = parseInt(maxPriceInput.value);
                    }
                }

                if (minVal < 0) {
                    minVal = 0;
                    minPriceInput.value = 0;
                }
                if (maxVal > maxLimit) {
                    maxVal = maxLimit;
                    maxPriceInput.value = maxLimit;
                }

                const percent1 = (minVal / maxLimit) * 100;
                const percent2 = (maxVal / maxLimit) * 100;

                sliderTrack.style.left = percent1 + '%';
                sliderTrack.style.width = (percent2 - percent1) + '%';
                priceDisplay.textContent = formatCurrency(minVal) + ' - ' + formatCurrency(maxVal);

                activeFilters.price.min = minVal;
                activeFilters.price.max = maxVal;
                currentPage = 1;
                updateView();
            }

            minPriceInput.addEventListener('input', updateSliderUIAndFilter);
            maxPriceInput.addEventListener('input', updateSliderUIAndFilter);

            // Chạy lần đầu
            updateSliderUIAndFilter();
        } else {
            updateView();
        }

        // --- XỬ LÝ PHÂN TRANG ---
        function renderPagination(totalPages) {
            paginationContainer.innerHTML = '';

            // Nếu không có món nào thỏa mãn bộ lọc (0 trang), thì mới ẩn thanh phân trang
            if (totalPages === 0)
                return;

            // Đã xóa dòng `if (totalPages <= 1) return;` để thanh phân trang luôn hiển thị

            // Nút Previous 
            let prevLi = document.createElement('li');
            prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
            prevLi.innerHTML = `<a class="page-link shadow-sm" href="#" aria-label="Previous">&laquo;</a>`;
            prevLi.addEventListener('click', (e) => {
                e.preventDefault();
                if (currentPage > 1) {
                    currentPage--;
                    updateView();
                    scrollToMenu();
                }
            });
            paginationContainer.appendChild(prevLi);

            // Các nút Số trang
            for (let i = 1; i <= totalPages; i++) {
                let li = document.createElement('li');
                li.className = `page-item ${currentPage === i ? 'active' : ''}`;
                li.innerHTML = `<a class="page-link shadow-sm" href="#">${i}</a>`;
                li.addEventListener('click', (e) => {
                    e.preventDefault();
                    currentPage = i;
                    updateView();
                    scrollToMenu();
                });
                paginationContainer.appendChild(li);
            }

            // Nút Next 
            let nextLi = document.createElement('li');
            nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
            nextLi.innerHTML = `<a class="page-link shadow-sm" href="#" aria-label="Next">&raquo;</a>`;
            nextLi.addEventListener('click', (e) => {
                e.preventDefault();
                if (currentPage < totalPages) {
                    currentPage++;
                    updateView();
                    scrollToMenu();
                }
            });
            paginationContainer.appendChild(nextLi);
        }

        function scrollToMenu() {
            const menuSection = document.getElementById('menu');
            if (menuSection) {
                window.scrollTo({top: menuSection.getBoundingClientRect().top + window.scrollY - 100, behavior: "smooth"});
            }
        }
    }
});

// --- XỬ LÝ CHUYỂN TAB TRONG TRANG CÁ NHÂN ---
document.addEventListener("DOMContentLoaded", function () {
    const profileTabs = document.querySelectorAll('.profile-sidebar .list-group-item');
    const tabContents = document.querySelectorAll('.profile-tab-content');

    if (profileTabs.length > 0) {
        for (let i = 0; i < profileTabs.length; i++) {
            profileTabs[i].addEventListener('click', function (e) {
                e.preventDefault();

                // Lấy ID của phần nội dung cần hiển thị
                const targetId = this.getAttribute('data-target');
                if (!targetId)
                    return;

                // 1. Đặt lại màu chữ và xóa class active của tất cả các thẻ trong menu
                for (let j = 0; j < profileTabs.length; j++) {
                    profileTabs[j].classList.remove('text-white', 'active-custom');
                    profileTabs[j].classList.add('text-secondary');
                }

                // 2. Làm nổi bật mục menu vừa được click
                this.classList.remove('text-secondary');
                this.classList.add('text-white', 'active-custom');

                // 3. Ẩn toàn bộ nội dung của các tab
                for (let k = 0; k < tabContents.length; k++) {
                    tabContents[k].classList.add('d-none');
                }

                // 4. Hiển thị nội dung của tab tương ứng
                const targetContent = document.getElementById(targetId);
                if (targetContent) {
                    targetContent.classList.remove('d-none');
                }
            });
        }
    }
});

// --- XỬ LÝ QUẢN LÝ ĐỊA CHỈ (THÊM, SỬA, XÓA, MẶC ĐỊNH) TẠI TRANG PROFILE ---
document.addEventListener("DOMContentLoaded", function () {
    const btnShowAdd = document.getElementById('btn-show-add-address');
    const formAdd = document.getElementById('form-add-address');
    const btnCancelAdd = document.getElementById('btn-cancel-address');
    const btnSubmitAdd = document.getElementById('btn-submit-address');
    const addressList = document.getElementById('address-list');
    const formTitle = document.getElementById('form-address-title');

    // Biến dùng để lưu thẻ div chứa địa chỉ đang được sửa (Nếu là null thì nghĩa là đang Thêm mới)
    let editingItem = null;

    if (btnShowAdd && formAdd && btnCancelAdd && btnSubmitAdd && addressList) {

        // 1. Hàm dùng chung để mở form (Cập nhật tiêu đề và điền dữ liệu)
        function openForm(isEdit, name = '', phone = '', detail = '') {
            if (formTitle)
                formTitle.innerText = isEdit ? 'Cập nhật địa chỉ' : 'Thêm địa chỉ giao hàng';
            document.getElementById('new-addr-name').value = name;
            document.getElementById('new-addr-phone').value = phone;
            document.getElementById('new-addr-detail').value = detail;

            formAdd.classList.remove('d-none');
            btnShowAdd.classList.add('d-none');
        }

        // 2. Click "Thêm địa chỉ mới"
        btnShowAdd.addEventListener('click', function () {
            editingItem = null; // Đặt về chế độ Thêm mới
            openForm(false);
        });

        // 3. Click "Hủy thao tác"
        btnCancelAdd.addEventListener('click', function () {
            formAdd.classList.add('d-none');
            btnShowAdd.classList.remove('d-none');
            editingItem = null;
        });

        // 4. Lắng nghe sự kiện Sửa/Xóa/Thiết lập mặc định cho toàn bộ danh sách
        addressList.addEventListener('click', function (e) {
            const item = e.target.closest('.address-item');
            if (!item)
                return;

            // Nếu người dùng bấm "Cập nhật"
            if (e.target.classList.contains('btn-edit-address')) {
                editingItem = item;
                const currentName = item.querySelector('.addr-name').innerText.trim();
                const currentPhone = item.querySelector('.addr-phone').innerText.trim();
                const currentDetail = item.querySelector('.addr-detail').innerText.trim();
                openForm(true, currentName, currentPhone, currentDetail);
            }

            // Nếu người dùng bấm "Xóa"
            if (e.target.classList.contains('btn-delete-address')) {
                item.remove();
                if (editingItem === item) {
                    btnCancelAdd.click();
                }
            }

            // Nếu người dùng bấm "Thiết lập mặc định"
            if (e.target.classList.contains('btn-set-default')) {
                // Bước 1: Xóa tag "Mặc định" ở tất cả các địa chỉ khác và hiện lại nút
                const allItems = addressList.querySelectorAll('.address-item');
                for (let i = 0; i < allItems.length; i++) {
                    const badge = allItems[i].querySelector('.default-badge');
                    if (badge)
                        badge.remove();

                    const setDefBtn = allItems[i].querySelector('.btn-set-default');
                    if (setDefBtn)
                        setDefBtn.classList.remove('d-none');
                }

                // Bước 2: Thêm tag "Mặc định" vào khối bên trái (.pe-3) của địa chỉ vừa bấm
                const badgeHTML = `<span class="badge border border-danger text-danger bg-white rounded-1 fw-normal default-badge mt-1" style="padding: 4px 8px;">Mặc định</span>`;
                item.querySelector('.pe-3').insertAdjacentHTML('beforeend', badgeHTML);

                // Bước 3: Ẩn nút "Thiết lập mặc định" đi
                e.target.classList.add('d-none');
            }
        });

        // 5. Xử lý khi bấm nút "Hoàn thành"
        btnSubmitAdd.addEventListener('click', function () {
            const nameVal = document.getElementById('new-addr-name').value.trim();
            const phoneVal = document.getElementById('new-addr-phone').value.trim();
            const detailVal = document.getElementById('new-addr-detail').value.trim();

            if (nameVal === '' || phoneVal === '' || detailVal === '') {
                alert('Vui lòng điền đầy đủ Họ tên, Số điện thoại và Địa chỉ cụ thể!');
                return;
            }

            if (editingItem) {
                // CHẾ ĐỘ SỬA
                editingItem.querySelector('.addr-name').innerText = nameVal;
                editingItem.querySelector('.addr-phone').innerText = phoneVal;
                editingItem.querySelector('.addr-detail').innerText = detailVal;
            } else {
                // CHẾ ĐỘ THÊM
                const newAddressHTML = `
                    <div class="border-bottom pb-4 mb-4 position-relative address-item d-flex justify-content-between align-items-start">
                        <div class="pe-3">
                            <div class="mb-1">
                                <span class="addr-name fw-bold text-dark fs-6 border-end pe-2 me-2">${nameVal}</span> 
                                <span class="addr-phone text-muted">${phoneVal}</span>
                            </div>
                            <div class="addr-detail text-muted mb-2" style="font-size: 0.9rem;">
                                ${detailVal.replace(/\n/g, '<br>')}
                            </div>
                        </div>

                        <div class="d-flex flex-column justify-content-between align-items-end text-end" style="height: 100%; min-width: 150px;">
                            <div class="mb-2">
                                <a href="javascript:void(0)" class="text-primary text-decoration-none me-2 btn-edit-address">Cập nhật</a>
                                <a href="javascript:void(0)" class="text-primary text-decoration-none btn-delete-address">Xóa</a>
                            </div>
                            <button class="btn btn-outline-secondary bg-white text-dark rounded-1 px-3 py-1 btn-set-default" style="font-size: 0.85rem; border-color: #d9d9d9;">Thiết lập mặc định</button>
                        </div>
                    </div>
`;
                addressList.insertAdjacentHTML('beforeend', newAddressHTML);
            }

            // Đóng form
            btnCancelAdd.click();
        });
    }

    // =========================================================
    // XỬ LÝ LỰA CHỌN "TỐI ĐA CHỌN 1" TRONG CHI TIẾT MÓN ĂN
    // =========================================================
    const max1Checkboxes = document.querySelectorAll('.max-1-checkbox');

    max1Checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            // Nếu ô này vừa được check
            if (this.checked) {
                // Lấy thuộc tính 'name' của ô này (VD: 'anHopVoi' hoặc 'monAnKem')
                const groupName = this.getAttribute('name');

                // Tìm tất cả các ô checkbox có CÙNG 'name'
                const sameGroupCheckboxes = document.querySelectorAll(`.max-1-checkbox[name="${groupName}"]`);

                // Gỡ check tất cả các ô khác trong cùng nhóm
                sameGroupCheckboxes.forEach(cb => {
                    if (cb !== this) {
                        cb.checked = false;
                    }
                });
            }
        });
    });
});

// =========================================================
// XỬ LÝ LOGIC POPUP: YÊU THÍCH VÀ GIỎ HÀNG
// =========================================================
document.addEventListener("DOMContentLoaded", function () {
    const toastEl = document.getElementById('wishlistToast');
    let toast = null;
    if (toastEl) {
        toast = new bootstrap.Toast(toastEl, {delay: 2500});
    }
    const toastBody = toastEl ? toastEl.querySelector('.toast-body') : null;

    // -----------------------------------------------------
    // 1. LOGIC MÓN YÊU THÍCH (WISHLIST)
    // -----------------------------------------------------
    const btnWishlists = document.querySelectorAll('.btn-wishlist');
    const wishlistBadge = document.querySelector('.wishlist-badge');
    const wishlistCountTexts = document.querySelectorAll('.wishlist-count-text');
    const wishlistEmpty = document.querySelector('.wishlist-empty');
    const wishlistHasItems = document.querySelector('.wishlist-has-items');
    const wishlistItemsList = document.querySelector('.wishlist-items-list');

    // Chặn dropdown đóng lại khi bấm xóa món yêu thích
    const wishlistDropdownMenu = document.querySelector('#wishlistDropdownContainer .cart-dropdown-menu');
    if (wishlistDropdownMenu) {
        wishlistDropdownMenu.addEventListener('click', function (e) {
            if (!e.target.closest('a[href]')) {
                e.stopPropagation();
            }
        });
    }

    let wishlistItems = [];

    function updateWishlistUI() {
        const count = wishlistItems.length;

        // Cập nhật số đếm trên icon
        if (wishlistBadge) {
            wishlistBadge.innerText = count;
            wishlistBadge.style.transform = "scale(1.5) translate(-30%, -30%)";
            setTimeout(() => {
                wishlistBadge.style.transform = "scale(1) translate(-50%, -50%)";
            }, 200);
        }

        wishlistCountTexts.forEach(el => el.innerText = count);

        // Đổi trạng thái hiển thị
        if (count === 0) {
            if (wishlistEmpty)
                wishlistEmpty.classList.remove('d-none');
            if (wishlistHasItems)
                wishlistHasItems.classList.add('d-none');
        } else {
            if (wishlistEmpty)
                wishlistEmpty.classList.add('d-none');
            if (wishlistHasItems)
                wishlistHasItems.classList.remove('d-none');
        }

        // Render HTML cho danh sách
        if (wishlistItemsList) {
            wishlistItemsList.innerHTML = '';
            wishlistItems.forEach((item, index) => {
                // Tạo cấu trúc thẻ giống với Giỏ Hàng (Bọc thẻ a, nút xóa bên ngoài)
                const html = `
                    <div class="d-flex align-items-center mb-3 wishlist-item-row" data-index="${index}" data-name="${item.name}">
                        <a href="${item.link}" class="d-flex align-items-center flex-grow-1 text-decoration-none text-dark action-go-detail">
                            <img src="${item.image}" alt="${item.name}" class="rounded shadow-sm" style="width: 50px; height: 50px; object-fit: cover;">
                            <div class="ms-3 flex-grow-1">
                                <h6 class="mb-0 fs-6 fw-bold text-truncate hover-primary" style="max-width: 160px;">${item.name}</h6>
                                <span class="text-primary-custom fw-bold">${item.price}</span>
                            </div>
                        </a>
                        <button type="button" class="btn btn-link text-danger p-0 ms-2 btn-remove-wishlist-item"><i class="fas fa-trash-alt"></i></button>
                    </div>
                `;
                wishlistItemsList.insertAdjacentHTML('beforeend', html);
            });
        }
    }

    // Xử lý sự kiện bấm tim trên thẻ món ăn
    if (btnWishlists.length > 0) {
        btnWishlists.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                const foodCard = this.closest('.food-card');
                if (!foodCard)
                    return;

                const titleEl = foodCard.querySelector('.food-title');
                const imgEl = foodCard.querySelector('.food-img');
                const priceEl = foodCard.querySelector('.price .text-danger') || foodCard.querySelector('.price');

                const itemName = titleEl ? titleEl.innerText.trim() : 'Món ăn';
                const itemImage = imgEl ? imgEl.src : '';
                const itemPrice = priceEl ? priceEl.innerText.replace(/<del>.*<\/del>/, '').trim() : '0 đ';
                const itemLink = titleEl ? titleEl.getAttribute('href') || 'ChiTietMonAn.jsp' : 'ChiTietMonAn.jsp';

                const isActive = this.classList.contains('active');

                if (!isActive) {
                    // Thêm vào danh sách
                    this.classList.add('active');
                    this.querySelector('i').classList.replace('far', 'fas');
                    wishlistItems.push({name: itemName, price: itemPrice, image: itemImage, link: itemLink});

                    if (toastEl && toastBody) {
                        toastEl.classList.remove('bg-secondary');
                        toastEl.classList.add('bg-primary-custom');
                        toastBody.innerHTML = `<i class="fas fa-heart me-2"></i> Đã thêm <b>${itemName}</b> vào yêu thích!`;
                        toast.show();
                    }
                } else {
                    // Xóa khỏi danh sách
                    this.classList.remove('active');
                    this.querySelector('i').classList.replace('fas', 'far');
                    wishlistItems = wishlistItems.filter(item => item.name !== itemName);

                    if (toastEl && toastBody) {
                        toastEl.classList.remove('bg-primary-custom');
                        toastEl.classList.add('bg-secondary');
                        toastBody.innerHTML = `<i class="fas fa-heart-broken me-2"></i> Đã xóa <b>${itemName}</b> khỏi yêu thích!`;
                        toast.show();
                    }
                }
                updateWishlistUI();
            });
        });
    }

    // Xử lý sự kiện xóa món yêu thích ngay trong menu Dropdown
    if (wishlistHasItems) {
        wishlistHasItems.addEventListener('click', function (e) {
            const removeBtn = e.target.closest('.btn-remove-wishlist-item');
            if (removeBtn) {
                e.preventDefault();
                e.stopPropagation();

                const itemRow = removeBtn.closest('.wishlist-item-row');
                if (itemRow) {
                    const itemName = itemRow.getAttribute('data-name');

                    // Xóa khỏi mảng dữ liệu
                    wishlistItems = wishlistItems.filter(item => item.name !== itemName);

                    // Cập nhật lại UI Dropdown
                    updateWishlistUI();

                    // Tìm lại tất cả các nút thả tim bên ngoài giao diện và tắt màu đỏ đi
                    btnWishlists.forEach(btn => {
                        const card = btn.closest('.food-card');
                        if (card) {
                            const titleEl = card.querySelector('.food-title');
                            if (titleEl && titleEl.innerText.trim() === itemName) {
                                btn.classList.remove('active');
                                btn.querySelector('i').classList.replace('fas', 'far');
                            }
                        }
                    });
                }
            }
        });
    }


    // -----------------------------------------------------
    // 2. LOGIC GIỎ HÀNG (CART) 
    // -----------------------------------------------------
    const addToCartBtns = document.querySelectorAll('.btn-add-cart');
    const cartBadge = document.querySelector('.cart-badge');
    const cartItemsListElement = document.querySelector('.cart-items-list');
    const cartEmptyUser = document.querySelector('.cart-empty-user');
    const cartHasItems = document.querySelector('.cart-has-items');
    const cartTotalPrice = document.querySelector('.total-price-display');

    // Chặn đóng popup khi click xóa món
    const cartDropdownMenu = document.querySelector('.cart-dropdown-menu');
    if (cartDropdownMenu) {
        cartDropdownMenu.addEventListener('click', function (e) {
            if (!e.target.closest('a[href]')) {
                e.stopPropagation();
            }
        });
    }

    //let cartItems = [];

    function formatCurrency(value) {
        return new Intl.NumberFormat('vi-VN').format(value) + 'đ';
    }

    function updateCartUI() {
        const count = cartItems.length;

        // Cập nhật số đếm badge
        if (cartBadge) {
            cartBadge.innerText = count;
            cartBadge.style.transform = "scale(1.5) translate(-30%, -30%)";
            setTimeout(() => cartBadge.style.transform = "scale(1) translate(-50%, -50%)", 200);
        }

        if (count === 0) {
            if (cartEmptyUser)
                cartEmptyUser.classList.remove('d-none');
            if (cartHasItems)
                cartHasItems.classList.add('d-none');
        } else {
            if (cartEmptyUser)
                cartEmptyUser.classList.add('d-none');
            if (cartHasItems)
                cartHasItems.classList.remove('d-none');

            if (cartItemsListElement) {
                cartItemsListElement.innerHTML = '';
                let total = 0;

                cartItems.forEach((item, index) => {
                    total += item.price;
                    const html = `
                        <div class="d-flex align-items-center mb-3 cart-item-row" data-index="${index}">
                            <a href="ChiTietMonAn.jsp" class="d-flex align-items-center flex-grow-1 text-decoration-none text-dark">
                                <img src="${item.image}" alt="${item.name}" class="rounded" style="width: 50px; height: 50px; object-fit: cover;">
                                <div class="ms-3 flex-grow-1">
                                    <h6 class="mb-0 fs-6 fw-bold text-truncate" style="max-width: 150px;">${item.name}</h6>
                                    <span class="text-primary-custom fw-bold">${formatCurrency(item.price)}</span> 
                                    <span class="text-muted small">x 1</span>
                                </div>
                            </a>
                            <button type="button" class="btn btn-link text-danger p-0 ms-2 btn-remove-item"><i class="fas fa-trash-alt"></i></button>
                        </div>
                    `;
                    cartItemsListElement.insertAdjacentHTML('beforeend', html);
                });

                if (cartTotalPrice)
                    cartTotalPrice.innerText = formatCurrency(total);
            }
        }
    }

    // Nút thêm vào giỏ
    if (addToCartBtns.length > 0) {
        addToCartBtns.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                const foodCard = this.closest('.food-card');
                if (!foodCard)
                    return;

                const titleEl = foodCard.querySelector('.food-title');
                const imgEl = foodCard.querySelector('.food-img');
                const priceEl = foodCard.querySelector('.price .text-danger') || foodCard.querySelector('.price');

                const itemName = titleEl ? titleEl.innerText.trim() : 'Món ăn';
                const itemImage = imgEl ? imgEl.src : '';
                const itemPriceStr = priceEl ? priceEl.innerText.replace(/\D/g, '') : '0';
                const itemPrice = parseInt(itemPriceStr) || 0;

                cartItems.push({name: itemName, image: itemImage, price: itemPrice});
                updateCartUI();

                if (toastEl && toastBody) {
                    toastEl.classList.remove('bg-secondary');
                    toastEl.classList.add('bg-primary-custom');
                    toastBody.innerHTML = `<i class="fas fa-cart-plus me-2"></i> Đã thêm <b>${itemName}</b> vào giỏ hàng!`;
                    toast.show();
                }
            });
        });
    }

    // Nút xóa món trong popup giỏ hàng
    if (cartHasItems) {
        cartHasItems.addEventListener('click', function (e) {
            const removeBtn = e.target.closest('.btn-remove-item');
            if (removeBtn) {
                e.preventDefault();

                const cartItemRow = removeBtn.closest('.cart-item-row');
                if (cartItemRow) {
                    const index = parseInt(cartItemRow.getAttribute('data-index'));
                    if (!isNaN(index) && index >= 0 && index < cartItems.length) {
                        cartItems.splice(index, 1);
                        updateCartUI();
                    }
                }
            }
        });
    }

    // Khởi tạo chạy lần đầu
    updateWishlistUI();
    updateCartUI();
});

// Tab thực đơn home
$(document).ready(function () {
    $('.menu-tabs .nav-link').on('click', function (e) {
        e.preventDefault();
        $('.menu-tabs .nav-link').removeClass('active');
        $(this).addClass('active');
    });
});


document.addEventListener("DOMContentLoaded", function () {
    // =========================================================
    // CHỈ XỬ LÝ PHÂN TRANG RESPONSIVE CHO TRANG THỰC ĐƠN
    // =========================================================
    const menuGrid = document.getElementById('menu-grid');
    const paginationContainer = document.getElementById('pagination');

    if (menuGrid && paginationContainer) {
        // Lấy toàn bộ danh sách các món ăn
        const menuItems = Array.from(document.querySelectorAll('.food-item'));

        // --- TÍNH TOÁN SỐ MÓN TRÊN 1 TRANG ---
        function getItemsPerPage() {
            const width = window.innerWidth;
            if (width >= 992) {
                return 9; // Desktop: 9 món
            } else if (width >= 576) {
                return 6; // Tablet: 6 món (như bạn yêu cầu)
            } else {
                return 4; // Mobile: 4 món
            }
        }

        let itemsPerPage = getItemsPerPage();
        let currentPage = 1;

        // Cập nhật lại phân trang nếu người dùng thay đổi kích thước trình duyệt hoặc xoay màn hình
        window.addEventListener('resize', function () {
            const newItemsPerPage = getItemsPerPage();
            if (itemsPerPage !== newItemsPerPage) {
                itemsPerPage = newItemsPerPage;
                currentPage = 1; // Reset về trang 1
                updateView();
            }
        });

        // Hàm cập nhật hiển thị món ăn theo trang
        function updateView() {
            const totalPages = Math.ceil(menuItems.length / itemsPerPage);

            // Đảm bảo không bị quá số trang
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;

            // 1. Ẩn tất cả các món
            menuItems.forEach(item => {
                item.classList.remove('show');
                item.style.display = 'none';
            });

            // 2. Chỉ hiển thị các món nằm trong phạm vi của trang hiện tại
            const itemsToShow = menuItems.slice(startIndex, endIndex);
            itemsToShow.forEach(item => {
                item.style.display = 'block';
                // Tạo hiệu ứng fade-in mượt mà
                setTimeout(() => item.classList.add('show'), 10);
            });

            // 3. Vẽ lại thanh phân trang
            renderPagination(totalPages);
        }

        // --- XỬ LÝ VẼ THANH PHÂN TRANG ---
        function renderPagination(totalPages) {
            paginationContainer.innerHTML = '';

            // Nếu chỉ có 1 trang hoặc không có trang nào thì ẩn thanh phân trang
            if (totalPages <= 1)
                return;

            // Nút Previous (Lùi)
            let prevLi = document.createElement('li');
            prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
            prevLi.innerHTML = `<a class="page-link shadow-sm" href="#" aria-label="Previous">&laquo;</a>`;
            prevLi.addEventListener('click', (e) => {
                e.preventDefault();
                if (currentPage > 1) {
                    currentPage--;
                    updateView();
                    scrollToMenu();
                }
            });
            paginationContainer.appendChild(prevLi);

            // Nút Số trang
            for (let i = 1; i <= totalPages; i++) {
                let li = document.createElement('li');
                li.className = `page-item ${currentPage === i ? 'active' : ''}`;
                li.innerHTML = `<a class="page-link shadow-sm" href="#">${i}</a>`;
                li.addEventListener('click', (e) => {
                    e.preventDefault();
                    currentPage = i;
                    updateView();
                    scrollToMenu();
                });
                paginationContainer.appendChild(li);
            }

            // Nút Next (Tiến)
            let nextLi = document.createElement('li');
            nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
            nextLi.innerHTML = `<a class="page-link shadow-sm" href="#" aria-label="Next">&raquo;</a>`;
            nextLi.addEventListener('click', (e) => {
                e.preventDefault();
                if (currentPage < totalPages) {
                    currentPage++;
                    updateView();
                    scrollToMenu();
                }
            });
            paginationContainer.appendChild(nextLi);
        }

        // Hàm cuộn lên đầu danh sách món ăn khi chuyển trang
        function scrollToMenu() {
            const menuSection = document.getElementById('menu');
            if (menuSection) {
                window.scrollTo({
                    top: menuSection.getBoundingClientRect().top + window.scrollY - 100,
                    behavior: "smooth"
                });
            }
        }

        // Kích hoạt chạy lần đầu khi load trang
        updateView();
    }
});