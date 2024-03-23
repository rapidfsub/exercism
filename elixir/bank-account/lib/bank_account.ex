defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  alias BankAccount.Balance

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start(&Balance.new/0)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    account |> Agent.update(&Balance.close/1)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    account |> Agent.get(&Balance.get/1)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    account |> Agent.get_and_update(&Balance.deposit(&1, amount))
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    account |> Agent.get_and_update(&Balance.withdraw(&1, amount))
  end
end

defmodule BankAccount.Balance do
  @account_closed {:error, :account_closed}
  @amount_must_be_positive {:error, :amount_must_be_positive}
  @not_enough_balance {:error, :not_enough_balance}

  def new() do
    0
  end

  def close(_balance) do
    nil
  end

  def get(nil), do: @account_closed
  def get(balance), do: balance

  def deposit(nil, _amount), do: {@account_closed, nil}
  def deposit(balance, amount) when amount > 0, do: {:ok, balance + amount}
  def deposit(balance, _amount), do: {@amount_must_be_positive, balance}

  def withdraw(nil, _amount), do: {@account_closed, nil}
  def withdraw(balance, amount) when balance < amount, do: {@not_enough_balance, balance}
  def withdraw(balance, amount) when amount > 0, do: {:ok, balance - amount}
  def withdraw(balance, _amount), do: {@amount_must_be_positive, balance}
end
