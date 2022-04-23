document.addEventListener("DOMContentLoaded", function (event) {
	var eToast = document.getElementById('meassage-toast');
	if (eToast) {
		var toast = new bootstrap.Toast(eToast);
		toast.show();
	}
});