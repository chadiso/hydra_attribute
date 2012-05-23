When /^load all "([^"]+)" records$/ do |klass|
  @records = Object.const_get(klass).all
end

When /^filter "([^"]+)" by:$/ do |klass, table|
  condition = table.hashes.each_with_object({}) { |item, hash| hash[item[:field].to_sym] = typecast_value(item[:value]) }
  @records  = Object.const_get(klass).where(condition)
end

When /^order "([^"]+)" records by "([^"]+)"$/ do |klass, attributes|
  @records = Object.const_get(klass)
  reverse  = false
  fields   = attributes.split.inject([]) do |items, attribute|
    name, direction = attribute.split('=')
    reverse = true if direction == 'desc'
    items << name.to_sym
  end

  @records = @records.order(fields)
  @records = @records.reverse_order if reverse
end

Then /^"(first|last)" record should have "([^"]+)"$/ do |method, attribute|
  name, value = typecast_attribute(attribute)
  @records.send(method).send(name).should == value
end

Then /^should be selected "(\d+)" records:$/ do |length, table|
  @records.should have(length.to_i).items
  table.hashes.each do |hash|
    record = @records.detect { |r| r.send(hash[:field]) == typecast_value(hash[:value]) }
    record.should_not be_nil
  end
end

Then /^records "(should|should_not)" have loaded associations:$/ do |should, table|
  table.hashes.each do |hash|
    @records.each do |record|
      record.association(hash[:association].to_sym).send(should, be_loaded)
    end
  end
end

Then /^"([^"]+)" records "(should|should_not)" have loaded associations:$/ do |klass, should, table|
  table.hashes.each do |hash|
    records = @records.select { |record| record.class.name == klass }
    records.each do |record|
      record.association(hash[:association].to_sym).send(should, be_loaded)
    end
  end
end