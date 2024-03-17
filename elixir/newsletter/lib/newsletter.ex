defmodule Newsletter do
  def read_emails(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def open_log(path) do
    path |> File.open!([:write])
  end

  def log_sent_email(pid, email) do
    pid |> IO.puts(email)
  end

  def close_log(pid) do
    pid |> File.close()
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    pid = log_path |> open_log()

    emails_path
    |> read_emails()
    |> Enum.each(fn email ->
      with :ok <- send_fun.(email) do
        pid |> log_sent_email(email)
      end
    end)

    pid |> close_log()
  end
end
