class Object
  unless defined?(instance_exec)
    def instance_exec(*args, &block)
      mname = "__instance_exec_#{Thread.current.object_id.abs}"
      eigen = class << self; self; end
      eigen.class_eval { define_method(mname, &block) }
      begin
        ret = send(mname, *args)
      ensure
        eigen.class_eval { undef_method(mname) } rescue nil
      end
      ret
    end
  end
end
