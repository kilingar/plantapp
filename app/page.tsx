import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-8 bg-gradient-to-b from-green-50 to-green-100 dark:from-gray-900 dark:to-gray-800">
      <main className="flex flex-col gap-8 items-center max-w-md w-full">
        <h1 className="text-4xl font-bold text-green-800 dark:text-green-400 text-center">
          🌱 Plant Diary
        </h1>
        
        <p className="text-center text-gray-700 dark:text-gray-300">
          Keep track of all your plants, organize them by zones, and share your green space with your household.
        </p>

        <div className="flex flex-col gap-4 w-full">
          <Link
            href="/auth/login"
            className="bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg text-center transition-colors"
          >
            Sign In
          </Link>
          
          <Link
            href="/dashboard"
            className="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 text-green-600 dark:text-green-400 font-semibold py-3 px-6 rounded-lg text-center border-2 border-green-600 dark:border-green-400 transition-colors"
          >
            View Demo
          </Link>
        </div>

        <div className="mt-8 text-sm text-gray-600 dark:text-gray-400 text-center">
          <p>Features:</p>
          <ul className="mt-2 space-y-1">
            <li>✓ Organize plants by zones</li>
            <li>✓ Track plant health and watering</li>
            <li>✓ Share with household members</li>
            <li>✓ Archive or remove plants</li>
          </ul>
        </div>
      </main>
    </div>
  );
}
