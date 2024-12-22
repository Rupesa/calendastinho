import { useState, useEffect } from 'react'
// import './App.css'
import './index.css'
import { Calendar } from "@/components/ui/calendar"

function App() {
  const [date, setDate] = useState<Date | undefined>(new Date())
  const [month, setMonth] = useState<number | undefined>(new Date().getMonth() + 1)
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [currentImageMonth, setCurrentImageMonth] = useState<number | undefined>(new Date().getMonth() + 1)

  useEffect(() => {
    if (month) {
      console.log(`Selected month: ${month}`)
    }
  }, [month])

  const handleMonthChange = (newDate: Date) => {
    setMonth(newDate.getMonth() + 1)
  }

  const handleImageClick = () => {
    setCurrentImageMonth(month)
    setIsModalOpen(true)
  }

  const handleCloseModal = () => {
    setIsModalOpen(false)
  }

  const handlePrevImage = () => {
    setCurrentImageMonth((prevMonth) => (prevMonth && prevMonth > 1 ? prevMonth - 1 : 12))
  }

  const handleNextImage = () => {
    setCurrentImageMonth((prevMonth) => (prevMonth && prevMonth < 12 ? prevMonth + 1 : 1))
  }

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-4xl font-bold mb-8 text-center">Calendastinho</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div className="flex justify-center">
          <Calendar
            mode="single"
            selected={date}
            onSelect={setDate}
            onMonthChange={handleMonthChange}
            className="rounded-md border w-fit h-fit"
          />
        </div>
        <div className="aspect-square relative">
          <img
            src={`/agostinho/${month}.jpg?height=800&width=600`}
            alt="Placeholder image"
            className="rounded-lg object-cover cursor-pointer"
            style={{ width: '100%' }}
            onClick={handleImageClick}
          />
        </div>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
          <div className="relative">
            <button
              className="absolute top-2 right-2 text-white text-2xl"
              onClick={handleCloseModal}
            >
              &times;
            </button>
            <button
              className="absolute left-2 top-1/2 transform -translate-y-1/2 text-white text-2xl"
              onClick={handlePrevImage}
            >
              &larr;
            </button>
            <img
              src={`/agostinho/${currentImageMonth}.jpg?height=800&width=600`}
              alt="Highlighted image"
              className="rounded-lg object-cover"
              style={{ maxHeight: '90vh', maxWidth: '90vw' }}
            />
            <button
              className="absolute right-2 top-1/2 transform -translate-y-1/2 text-white text-2xl"
              onClick={handleNextImage}
            >
              &rarr;
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

export default App
