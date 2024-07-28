# ---------- extend directive will add target module to singleton class's ancestors ----------
#
# C.singleton_class.ancestors
# =>
# [#<Class:C>,
#  M,
#  #<Class:Object>,
#  #<Class:BasicObject>,
#  Class,
#  Module,
#  Object,
#  JSON::Ext::Generator::GeneratorMethods::Object,
#  PP::ObjectMixin,
#  Kernel,
#  BasicObject]
#
#  So, M's methods can be searched when C receive some class method

module M
  def hello
    puts "C's class method"
  end
end

class C
  extend M

  def self.hoge
    puts "hoge"
  end
end

C.hello
C.hoge
