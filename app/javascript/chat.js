import { createConsumer } from "@rails/actioncable"

console.log("chat.js is being executed");

document.addEventListener('turbo:load', () => {
    console.log("turbo:load event fired in chat.js");
    const consumer = createConsumer()
    
    const chatChannel = consumer.subscriptions.create("ChatChannel", {
        connected() {
            console.log("Connected to the chat channel")
        },
        disconnected() {
            console.log("Disconnected from the chat channel")
        },
        received(data) {
            console.log("Received data:", data);
            const messagesContainer = document.getElementById('messages-container');
            if (messagesContainer && data.message) {
                const messageElement = document.createElement('p');
                messageElement.className = 'text-left mt-3 text-gray-800 dark:text-neutral-200';
                messageElement.innerHTML = `
                    <span>${data.created_at}</span>:
                    <span class="font-bold">${data.message.content}</span>
                `;
                messagesContainer.prepend(messageElement);
            }
        }
    })
})