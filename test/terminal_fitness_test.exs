defmodule TerminalFitnessTest do
  use ExUnit.Case
  # doctest TerminalFitness

  test "set up a server and test the connection" do
    spawn(fn -> TerminalFitness.Server.listen(10004) end)
    socket = Socket.TCP.connect! "localhost", 10004, packet: :line
    # IO.inspect sock
    socket |> Socket.Stream.send!("quit\n\r")
    # response = socket |> Socket.Stream.recv!()
    socket |> Socket.Stream.close

    assert socket != nil
    # assert response == nil
  end
end
