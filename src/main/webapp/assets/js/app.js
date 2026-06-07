(function () {
    const roleSelect = document.getElementById("roleSelect");
    const patientFields = document.getElementById("patientFields");
    const doctorFields = document.getElementById("doctorFields");

    function syncRoleFields() {
        if (!roleSelect || !patientFields || !doctorFields) return;
        const isDoctor = roleSelect.value === "DOCTOR";
        doctorFields.style.display = isDoctor ? "block" : "none";
        patientFields.style.display = isDoctor ? "none" : "block";
        doctorFields.querySelectorAll("input, textarea").forEach((input) => input.required = isDoctor && ["hospital", "specialization", "education"].includes(input.name));
    }

    if (roleSelect) {
        roleSelect.addEventListener("change", syncRoleFields);
        syncRoleFields();
    }

    document.querySelectorAll("textarea[name='disease']").forEach((field) => {
        field.addEventListener("input", () => {
            const words = field.value.trim().split(/\s+/).filter(Boolean).length;
            field.setCustomValidity(words >= 20 && words <= 30 ? "" : "Please enter a disease description in 20 to 30 words.");
        });
    });
})();
