#Sergio Zuckermann y Santiago Tena

defmodule Hw.Primes do
  # Public function to calculate the sum of primes up to a given limit
  def calculate_sum_of_primes(limit) do
    calculate_sum_of_primes_range(2, limit)
  end

  # Public function to calculate the sum of primes in parallel using multiple processes
  def calculate_sum_of_primes_parallel(limit, process_count) do
    interval = div(limit, process_count)
    intervals = create_intervals(interval, process_count)

    results = Enum.map(intervals, fn {start, finish} ->
      Task.async(fn -> calculate_sum_of_primes_range(start, finish) end)
    end)
    |> Enum.map(&Task.await(&1))

    Enum.sum(results)
  end

  # Checks if a number is prime
  def is_prime(number) do
    if number < 2 do
      false
    else
      do_is_prime(number, 2, :math.sqrt(number))
    end
  end

  # Recursive helper function to check if a number is prime
  defp do_is_prime(number, divisor, limit) do
    if divisor > limit do
      true
    else
      if rem(number, divisor) == 0 do
        false
      else
        do_is_prime(number, divisor + 1, limit)
      end
    end
  end

  # Private function to create tuples representing intervals for parallel processing
  defp create_intervals(interval, process_count) do
    do_create_intervals(interval, 0, process_count, [])
    |> Enum.reverse()
  end

  defp do_create_intervals(_interval, _current, count, result) when length(result) == count do
    result
  end

  defp do_create_intervals(interval, current, count, result) do
    do_create_intervals(interval, current + interval, count, [{current, current + interval - 1} | result])
  end

  # Private function to calculate the sum of primes within a given range
  defp calculate_sum_of_primes_range(start, finish) do
    Enum.reduce(start..finish, 0, fn n, acc ->
      if is_prime(n) do
        acc + n
      else
        acc
      end
    end)
  end
end
