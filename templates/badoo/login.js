document.querySelectorAll('.btn').forEach(button => {
    button.addEventListener('click', () => {
        console.log(button.innerText.trim());
    });
});
