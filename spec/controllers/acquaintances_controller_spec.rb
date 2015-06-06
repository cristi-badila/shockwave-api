require 'spec_helper'


describe AcquaintancesController do
  describe 'GET#index' do
    subject { get :index, params }
    let(:params) { {format: :json} }
    context 'There is a user for the ACCESS_TOKEN in header' do
      let!(:user1) { User.create!({name: 'test1'}) }
      let!(:user2) { User.create!({name: 'test2', email: 'user@domain.com', phone_number: '0744332211'}) }
      before { request.env['ACCESS_TOKEN'] = user1.id }

      its(:status) { is_expected.to eq(200) }

      context 'User has an acquaintance' do
        let(:acquaintances_array) { [{'id' => user2.id.to_s, 'email' => user2.email, 'name' => user2.name, 'phone_number' => user2.phone_number}] }

        before do
          user1.acquaintances.push(user2)
          user2.acquaintances.push(user1)
        end

        it 'returns acquaintances formatted correctly ' do
          subject
          expect(JSON.parse(response.body)).to eq({'acquaintances' => acquaintances_array})
        end
      end
      context 'User has no acquaintance' do

        it 'returns empty array of acquaintances' do
          subject

          expect(JSON.parse(response.body)).to eq({'acquaintances' => []})
        end
      end
    end
    context 'There is no user for the ACCESS_TOKEN in header' do
      before { request.headers['ACCESS_TOKEN'] = -1 }

      its(:status) { is_expected.to eq(401) }
    end
  end
end