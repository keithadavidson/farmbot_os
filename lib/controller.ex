defmodule Controller do
  # use Application
  require Logger
  use Supervisor

  def init(_args) do
    children = [
      worker(Auth, [[]]),
      supervisor(RPCSupervisor, [[]],   restart: :permanent ),
      supervisor(BotCommandSupervisor, [[]], restart: :permanent),
      worker(BotStatus, [[]]  ,             restart: :permanent ),
      supervisor(SerialSupervisor, [[]],    restart: :permanent ),
      supervisor(MqttSupervisor, [[]],      restart: :permanent ),
      supervisor(SequenceSupervisor, [[]],      restart: :permanent ),
      worker(BotSync, [[]]  ,             restart: :permanent )
    ]
    opts = [strategy: :one_for_all, name: Controller.Supervisor]
    supervise(children, opts)
  end

  def start_link(args) do
    Logger.debug("Starting Controller")
    Supervisor.start_link(__MODULE__, args)
  end
end
