describe Repo do
  before  { @repo = create(:repo) }
  subject { @repo }

  it { is_expected.to respond_to(:name) }

  it 'is valid with a name' do
    repo = Repo.new(name: 'Test Repo')
    expect(repo).to be_valid
  end

 it 'is invalid without a name' do
   repo = Repo.new(name: nil)
   repo.valid?
   expect(repo.errors[:name]).to include("can't be blank")
 end

 it 'is invalid with a duplicate name' do
   repo2 = build(:repo, name: @repo.name)
   repo2.valid?
   expect(repo2.errors[:name]).to include('has already been taken')
 end
end
