require 'concurrent'
require 'open3'
require 'io/wait'

module ExecSimple
  VERSION = "0.1.0"

  # Run a command. Optionally log results from stadard output and error
  # with a logger object. Optionally set a timeout as a maximum time to
  # wait until the process is killed.
  # @param [String] cmd The command to run
  # @param [Logging::Logger] log An optional logger object to use for output
  # @param [Int] timeout An optional timeout to wait until the process is killed.
  # @returny [Array] Either return an array of [output, error, exit_code] or 
  # just the exit_code if a log-object was provided
  def self.run cmd, log: nil, timeout: nil
    # run the command concurrently to manage timeouts
  
    out = ""
    err = ""
    stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
    # we don't need stdin
    stdin.close
    # run readers on stdin and stderr
    op = Concurrent::Promise.execute do
      while( not stdout.eof? )
        #stdout.wait_readable
        #cur = stdout.read
        cur = stdout.readpartial(4096)
        if log.nil? then out << cur else log.info cur.chomp end
      end
    end
    ep = Concurrent::Promise.execute do
      while( not stderr.eof? )
        #stdout.wait_readable
        #cur = stdout.read
        cur = stderr.readpartial(4096)
        if log.nil? then err << cur else log.error cur.chomp end
      end
    end
    # 
    pid = wait_thr[:pid]

    future = Concurrent::Future.execute do
        wait_thr.value
      end
    # get the future's value
    exit_code = future.value(timeout)
    exitstatus = if exit_code.nil? then nil else exit_code.exitstatus end
    
    # if we didn't yet get a value, kill the process
    if wait_thr.alive?
      Process.kill('TERM', pid)
      sleep 1
      # check if it terminated successfully
      if wait_thr.alive?
        # if not give it some more time
        sleep 3
        # and then kill it
        Process.kill('KILL', pid) if wait_thr.alive?
      end
    end
    
    # finishing up
    stdout.close
    stderr.close

    # get the results
    return exitstatus if not log.nil?
    [out, err, exitstatus]
  end
end
