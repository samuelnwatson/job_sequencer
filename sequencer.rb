class Sequencer
  def self.call(args)
    self.new.call(args)
  end

  def call(args)
    if valid_input?(args)
      queue_jobs(args)
    else
      "Invalid args given: #{args}"
    end
  end

  private

  def queue_jobs(args)
    if args&.empty?
      ""
    elsif args.is_a?(String)
      sort_jobs(parse_string(args))
    else
      sort_jobs(args)
    end
  end

  def parse_string(str)
    hash_from_array(array_from_string(str))
  end

  def valid_input?(args)
    if args.is_a?(String) || args.is_a?(Hash)
      true
    else
      false
    end
  end

  def array_from_string(str)
    arr = str.split(" ")
    format_array(arr)
  end

  def format_array(arr)
    result = []

    arr.each_with_index do |elem, index|
      if elem == "=>"
        if index < arr.length-2
          unless arr[index+1].match(/[[:alpha:]]/) && arr[index+2].match(/[[:alpha:]]/)
            result << ""
          end
        end
        if index == arr.length-1
          result << ""
        end
      end

      unless elem == "=>"
        result << elem
      end
    end

    result
  end

  def hash_from_array(arr)
    if arr.each_slice(2)&.to_a&.to_h
      arr.each_slice(2).to_a.to_h
    else
      "Failed to create hash"
    end
  end

  def sort_jobs(jobs)
    if jobs.is_a?(String)
      jobs
    else
      if self_reference?(jobs)
        "Cannot have jobs refer to themselves"
      elsif circular_references?(jobs)
        "Cannot have circular job dependencies"
      else
        list_jobs(jobs)
      end
    end
  end

  def circular_references?(jobs)
    result = false
    jobs.each do |key, value|
      jobs.any? do |k, v|
        if key == v && value == k
          result = true
        end
      end
    end
    result
  end

  def self_reference?(jobs)
    jobs.any? do |key, value|
      key == value
    end
  end

  def order_jobs(jobs)
    jobs.sort_by {|key, value| value}.flatten.each_slice(2).to_a.to_h.keys
  end

  def list_jobs(jobs)
    order_jobs(jobs).join("")
  end
end
