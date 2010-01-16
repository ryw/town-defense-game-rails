class Array
   def random 
     self[Kernel::rand(self.length)]
   end
end