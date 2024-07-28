# ---------- include directive will add target module to class ancestors ----------
#
# C.ancestors
# => [C, M, Object, JSON::Ext::Generator::GeneratorMethods::Object, PP::ObjectMixin, Kernel, BasicObject]
#
# ---------- About instance method ----------
# if C's instance receive method, it will serarch this ancestors method from bottom
# Because C'ancestor includes M, module M's instance method can be searched by C's instance
#
# ---------- About class method ----------
# class method searching algorithm is here -> https://qiita.com/tsuzuki_takaaki/items/e2f4b6d5cfe289b3d54a
# class method search target is singleton_class's ancestors
# include directive will not add target module to singleton_class's ancestors, so class C can not receive module M's class method

module M
  def self.hello
    puts "class method"
  end

  def hello
    puts "instance method"
  end
end

class C
  include M

  def self.hoge
    puts "hoge"
  end
end

instance = C.new
instance.hello

# C.singleton_class.ancestors
# =>
# [#<Class:C>,
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
# this does not work
C.hello
