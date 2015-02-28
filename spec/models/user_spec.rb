describe User do
  before  { @user = create(:user) }
  subject { @user }

  it { is_expected.to respond_to(:name)     }
  it { is_expected.to respond_to(:uid)      }
  it { is_expected.to respond_to(:username) }

  it 'is valid with a uid and a username' do
    user = User.new(uid: '123456', username: 'jsmith')
    expect(user).to be_valid
  end

  it 'is valid with a name, uid, and username' do
    user = User.new(name: 'John Smith', uid: '123456', username: 'jsmith')
    expect(user).to be_valid
  end

 it 'is invalid without a uid' do
   user = User.new(uid: nil)
   user.valid?
   expect(user.errors[:uid]).to include("can't be blank")
 end

 it 'is invalid without a username' do
   user = User.new(username: nil)
   user.valid?
   expect(user.errors[:username]).to include("can't be blank")
 end

 it 'is invalid with a duplicate uid' do
   user2 = build(:user, uid: @user.uid)
   user2.valid?
   expect(user2.errors[:uid]).to include('has already been taken')
 end
end
