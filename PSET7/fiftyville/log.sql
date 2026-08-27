-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Keep a record of any SQL queries you execute as you solve the mystery.

-- 1. Get transcripts from interviews to find clues
SELECT name, transcript FROM interviews WHERE year = 2025 AND transcript LIKE '%bakery%';

-- 2. Check bakery security logs for cars exiting within 10 minutes of the theft (10:15)
SELECT license_plate FROM bakery_security_logs WHERE year = 2025 AND month = 7 AND day = 28 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = 'exit';

-- 3. Check ATM transactions on Leggett Street on the morning of the theft
SELECT name FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.year = 2025 AND atm_transactions.month = 7 AND atm_transactions.day = 28 AND atm_transactions.atm_location = 'Leggett Street' AND atm_transactions.transaction_type = 'withdraw';

-- 4. Check phone calls lasting less than a minute on the day of the theft
SELECT name FROM people JOIN phone_calls ON people.phone_number = phone_calls.caller WHERE phone_calls.year = 2025 AND phone_calls.month = 7 AND phone_calls.day = 28 AND phone_calls.duration < 60;

-- 5. Find the earliest flight out of Fiftyville on the next day (July 29, 2025)
SELECT name FROM people JOIN passengers ON people.passport_number = passengers.passport_number JOIN flights ON passengers.flight_id = flights.id WHERE flights.year = 2025 AND flights.month = 7 AND flights.day = 29 ORDER BY flights.hour ASC, flights.minute ASC LIMIT 1;

-- 6. Find the receiver of the call from Bruce to identify the accomplice
SELECT name FROM people JOIN phone_calls ON people.phone_number = phone_calls.receiver WHERE phone_calls.year = 2025 AND phone_calls.month = 7 AND phone_calls.day = 28 AND phone_calls.caller = (SELECT phone_number FROM people WHERE name = 'Bruce') AND phone_calls.duration < 60;

-- 7. Find the destination city of the thief's flight
SELECT city FROM airports JOIN flights ON airports.id = flights.destination_airport_id JOIN passengers ON flights.id = passengers.flight_id JOIN people ON passengers.passport_number = people.passport_number WHERE people.name = 'Bruce' AND flights.year = 2025 AND flights.month = 7 AND flights.day = 29 ORDER BY flights.hour ASC, flights.minute ASC LIMIT 1;
