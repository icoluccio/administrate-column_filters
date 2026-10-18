RSpec.shared_examples 'an association builder' do |missing:|
  it 'names the field when the model has no such association' do
    expect { described_class.new(missing).to_proc.call(Article.all, '1') }
      .to raise_error(Administrate::ColumnFilters::Exceptions::UnknownAssociation,
                      /Article has no association #{Regexp.escape(missing.inspect)}/)
  end
end
