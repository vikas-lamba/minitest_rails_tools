# Allows for some automagic association tests.
# Expects 'subject' to be defined. E.g.
#   subject { FactoryGirl.create :foo }

def must_validate_presence_of(attribute_name, options = {})
  it "validates_presence_of :#{attribute_name.to_s.parameterize.underscore}" do
    subject.send "#{attribute_name}=".to_sym, nil
    subject.wont_be :valid?
    message = options[:message] || "can't be blank"
    subject.errors.messages[attribute_name.to_sym].must_include message
  end
end

def must_validate_uniqueness_of(attribute_name, options = {})
  it "validates_uniqueness_of :#{attribute_name.to_s.parameterize.underscore}" do
    other = subject.class.new
    other.send "#{attribute_name}=".to_sym, subject.send(attribute_name)
    other.wont_be :valid?
    message = options[:message] || "has_already been taken"
    other.errors.messages[attribute_name.to_sym].must_include message
  end
end

def must_validate_length_of(attribute_name, options = {})
  it "validates_length_of :#{attribute_name.to_s.parameterize.underscore}" do
    if options[:minimum]
      subject.send "#{attribute_name}=".to_sym, (0..options[:minimum] - 1).to_a
      subject.wont_be :valid?
      message = options[:message] || "is too short (minimum is #{options[:minimum]}"
      subject.errors.messages[attribute_name.to_sym].must_include message
    end
    if options[:maximum]
      subject.send "#{attribute_name}=".to_sym, (0..options[:maximum] + 1).to_a
      subject.wont_be :valid?
      message = options[:message] || "is too long (maximum is #{options[:maximum]}"
      subject.errors.messages[attribute_name.to_sym].must_include message
    end
  end
end
