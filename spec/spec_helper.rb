require "executors"

ID = "id"

def create_executor
  return Java::java.util.concurrent.Executors.new_single_thread_executor
end