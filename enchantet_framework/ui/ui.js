let ui
function CreateMenu(data) {
    const menu = document.getElementById('menu');
    menu.innerHTML = '';
    let activeIndex = 0;

    function setActive(index) {
        const boxes = menu.querySelectorAll('.menu-item');
        boxes.forEach((box, i) => {
            if (i === index) {
                box.classList.add('active', 'scale-110');
            } else {
                box.classList.remove('active', 'scale-110');
            }
        });
    }

    data.forEach((item, index) => {
        const box = document.createElement('div');
        box.classList.add('w-[80%]', 'mx-5', 'm-2', 'p-2', 'bg-zinc-700', 'rounded-lg', 'flex', 'flex-col', 'items-center', 'transition', 'duration-150', 'ease-in-out', 'menu-item', 'hover:scale-110'); // Add 'menu-item' class

        const label = document.createElement('h2');
        label.textContent = item.label;
        label.classList.add('text-l', 'font-bold', 'm-1', 'text-white', 'text-center');

        box.addEventListener('click', () => {
            const postData = {
                event: item.event,
                type: 'menu'
            };
        
            if (item.args) {
                postData.args = item.args;
            }
        
            $.post('https://enchantet_framework/CallEvent', JSON.stringify(postData));
        });
        
        box.appendChild(label);
        menu.appendChild(box);

    });


    document.addEventListener('keydown', (event) => {
        if (ui === 'menu') {
            const boxes = menu.querySelectorAll('.menu-item');
            const maxIndex = data.length - 1;
    
            if (event.key === 'ArrowUp') {
                event.preventDefault();
                activeIndex = activeIndex > 0 ? activeIndex - 1 : maxIndex;
                setActive(activeIndex);
                boxes[activeIndex].scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else if (event.key === 'ArrowDown') {
                event.preventDefault();
                activeIndex = activeIndex < maxIndex ? activeIndex + 1 : 0;
                setActive(activeIndex);
                boxes[activeIndex].scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else if (event.key === 'Enter') {
                event.preventDefault();
                const activeBox = menu.querySelector('.menu-item.active');
                if (activeBox) {
                    activeBox.click();
                }
            } else if (event.key === 'Backspace') {
                $.post('https://enchantet_framework/Close', JSON.stringify());
            } else if (event.key === 'Escape') {
                $.post('https://enchantet_framework/Close', JSON.stringify());
            }
        }
    });
}

function createInput(header, event) {
    const doneButton = document.getElementById('doneButton');
    const inputText = document.getElementById('inputTextHeader');
    inputText.textContent = header;
    const inputData = document.getElementById('inputData');
    inputData.value = '';

    function handleDoneClick() {
        $.post('https://enchantet_framework/CallEvent', JSON.stringify({
            input: inputData.value,
            event: event,
            type: 'input'
        }));
        $.post('https://enchantet_framework/Close', JSON.stringify());

        doneButton.removeEventListener('click', handleDoneClick);
    }
    doneButton.addEventListener('click', handleDoneClick);
}


window.addEventListener('message', function(event) {
    console.log('Opens '+event.data.open)
    if (event.data.open == 'menu') {
        ui = 'menu';
        CreateMenu(event.data.functions);
        $("#menu").show(500)
    } else if (event.data.open == 'input') {
        createInput(event.data.header, event.data.event)
        $("#input").show(500)
    } else {
        ui = '';
        $("#input").hide(500)
        $("#menu").hide(500)
    }
})

$("#menu").hide()

$("#input").hide()