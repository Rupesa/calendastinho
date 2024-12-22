import React from 'react'
// import './App.css'
import './index.css'
import { Calendar } from "@/components/ui/calendar"

function App() {
  const [date, setDate] = React.useState<Date | undefined>(new Date())
  
  return (
    <div className="container mx-auto p-4">
      <h1 className="text-4xl font-bold mb-8 text-center">Calendastinho</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <Calendar
          mode="single"
          selected={date}
          onSelect={setDate}
          className="rounded-md border"
        />
        <div className="aspect-square relative">
          <img
            src="/placeholder.svg?height=600&width=600"
            alt="Placeholder image"
            className="rounded-lg object-cover"
            style={{ width: '100%', height: '100%' }}
          />
        </div>
      </div>
    </div>
  )
}

export default App
