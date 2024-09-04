import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

const chatChannel = consumer.subscriptions.create("ChatChannel", {
    connected() {
        console.log("Connected to the chat channel")
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        const messagesContainer = document.getElementById('messages')
        messagesContainer.insertAdjacentHTML('beforeend', `<p>${data.message}</p>`)
      },

    speak(message) {
        this.perform('speak', { message: message })
    }
})

document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('new-message-form')
    const input = document.getElementById('message-input')
  
    form.addEventListener('submit', (e) => {
      e.preventDefault()
      console.log('Form submitted')
      if (input.value.length > 0) {
        console.log('Sending message:', input.value) 
        fetch('/messages', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ message: { content: input.value } })
        })
        .then(response => {
          console.log('Response status:', response.status)
          return response.json()
        })
        .then(data => {
          console.log('Response data:', data)
          if (data.success) {
            input.value = ''
          } else {
            console.error('Failed to send message:', data.error)
          }
        })
        .catch(error => console.error('Error:', error))
      }
    })
})