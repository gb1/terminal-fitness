defmodule TerminalFitness.Server do

  def listen(port), do: listen(port, &handler/1)
  def listen(port, handler) do
    IO.puts "listen"
    Socket.TCP.listen!(port, packet: :line)
    |> accept(handler)
  end

  def accept(listening_socket, handler) do
    IO.puts "accept"
    socket = Socket.TCP.accept!(listening_socket)
    socket |> Socket.Stream.send!(welcome())
    socket |> Socket.Stream.send!(options())

    spawn (fn -> handle(socket, handler) end)
    accept(listening_socket, handler)
  end

  def handle(socket, handler) do
    IO.puts "handle"

    case Socket.Stream.recv(socket) do
      {:ok, nil} ->
        socket |> Socket.Stream.shutdown
      {:ok, "quit\r\n"} ->
        socket |> Socket.Stream.shutdown

      {:ok, "1\r\n"} ->
          pushups(socket)

      {:ok, incoming} ->
        IO.inspect incoming
        socket |> Socket.Stream.send!(handler.(incoming))
        handle(socket, handler)

      {:error, _incoming} ->
        socket |> Socket.Stream.shutdown

    end
  end

  def handler(line) do
    cond do
      line =~ ~r/quit/ -> quit()
      line =~ ~r/help/ -> options()
      # line =~ ~r/1/ -> pushups()
      line =~ ~r/2/ -> squats()
      line =~ ~r/3/ -> plank()
      true ->
        "I'm not sure what you mean by '"
        <> String.trim(line)
        <> "' , type 'help' for options\n\r"
    end

  end

  def welcome do

    contents = File.read! "pics/weightlifter.txt"

    IO.ANSI.clear() <>
    IO.ANSI.green() <>
     "\n" <>
     "   *==================================*\n\r" <>
     "   *    Welcome to Terminal Fitness   *\n\r" <>
     "   *==================================*\n\r" <>
     contents <>
     "\nCHOOSE AN OPTION:\n\r"
  end

  def options do

    IO.ANSI.blue() <>
    "1. Pushup challenge\n\r" <>
    "2. Squat challenge\n\r" <>
    "3. Plank challenge\n\r" <>
    "Choose 1-3: " <> IO.ANSI.white()
  end

  def pushups(socket, week, day) do
    socket |> Socket.Stream.send!(
      "ok, do this..."
    )
    handle(socket, &handler/1)
  end
  def pushups(socket, week) do

    socket |> Socket.Stream.send!(
      "OK, what day are you on?: (1-3) "
    )
    day = Socket.Stream.recv(socket)
    pushups(socket, week, day)
  end
  def pushups(socket) do
    socket |> Socket.Stream.send!(
      IO.ANSI.clear <>
      TerminalFitness.PushUps.greeting()
    )
    week = Socket.Stream.recv(socket)
    pushups(socket, week)
  end

  def squats do
    IO.ANSI.clear <>
    "squats it is!"
  end

  def plank do
    IO.ANSI.clear <>
    "plank it is!"
  end

  def quit() do
    # socket |> Socket.Stream.shutdown
  end

end
