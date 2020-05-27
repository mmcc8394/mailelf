document.addEventListener('turbolinks:load', login_show_password_reset_dialogue);

function login_show_password_reset_dialogue() {
    let forgot_password = document.getElementById('forgot-password');
    if(forgot_password) {
        login_add_extra_classes_for_password_reset(forgot_password);

        forgot_password.onclick = function () {
            login_build_forgot_password_dialogue();
            return false;
        };
    }
}

function login_add_extra_classes_for_password_reset(forgot_password) {
    forgot_password.setAttribute("data-toggle", "modal");
    forgot_password.setAttribute("data-target", "#modal-box");
}

function login_build_forgot_password_dialogue() {
    build_modal_title();
    build_modal_body();
}

function build_modal_title() {
    let modal_title = document.getElementsByClassName('modal-title')[0];
    modal_title.innerHTML = 'Request Password Reset'
}

function build_modal_body() {
    $.ajax({ url: '/login/lost_password_email.js' });
}
