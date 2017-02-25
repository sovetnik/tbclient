require 'rails_helper'

RSpec.describe User, type: :model do
  describe '##sso_authenticate(token)' do
    let!(:user) { create :user, token: SecureRandom.hex }
    let(:subject) { described_class.sso_authenticate(token) }

    context 'one of users has same token' do
      let(:token) { user.token }
      it 'returnes user' do
        expect(subject).to eq user
      end
    end

    context 'no one of users has same token' do
      let(:token) { SecureRandom.hex }
      it 'returnes user' do
        expect(subject).to eq false
      end
    end

  end
end
