# で、普通に考えたらclass methodもinstance methodもどっちもmixinできるようにしたいっていうneedsがあるはず
#
# ---------- Module#included ----------
# https://docs.ruby-lang.org/ja/latest/method/Module/i/included.html
# > self が Module#include されたときに対象のクラスまたはモジュールを引数にしてインタプリタがこのメソッドを呼び出します。
# ↑ の仕組みを使って、methodごとにincludeするのかextendするのかを分けるようにすることができる

module M
  # @mod: Module which includes this module
  def self.included(mod)
    mod.extend S
    mod.include T
  end

  module S
    def fuga_class
      puts "As class method"
    end
  end

  module T
    def hoge_instance
      puts "As instance method"
    end
  end
end

class C
  include M
end

C.fuga_class
c = C.new
c.hoge_instance

# ↑をよしなにやってくれるのがActiveSupport::Concern

require 'active_support'
module N
  extend ActiveSupport::Concern
  # M.singleton_class.ancestors
  # =>
  # [#<Class:M>,
  #  ActiveSupport::Concern, <-
  #  Module,
  #  Object,
  #  JSON::Ext::Generator::GeneratorMethods::Object,
  #  PP::ObjectMixin,
  #  Kernel,
  #  BasicObject]
  #
  #  ActiveSupport::Concernに定義されているmethodがclassmethodとして追加される
  #  M.singleton_methods
  #  => [:append_features, :prepend_features, :class_methods, :included, :prepended]
 
  # https://github.com/rails/rails/blob/c01ee683aa700b109f704a5b6611107fe2dc5476/activesupport/lib/active_support/concern.rb#L155C5-L170C8
  # "Evaluate given block in context of base class"なので、includeされるクラスにこの内容がまんま展開される
  # so that you can write class macros here.
  included do
    def self.hogeeeeee
      puts "hogeeeeee(class method)"
    end

    def instance_hogeeeeee
      puts "hogeeeeee(instance method)"
    end
  end

  # https://github.com/rails/rails/blob/c01ee683aa700b109f704a5b6611107fe2dc5476/activesupport/lib/active_support/concern.rb#L209C5-L215C8
  class_methods do
    def fugaaaaaa
      puts "fugaaaaaa(class method)"
    end
  end
end

class C
  include N
end

C.hogeeeeee
C.fugaaaaaa
c = C.new
c.instance_hogeeeeee
