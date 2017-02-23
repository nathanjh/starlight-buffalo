require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  shared_examples 'public access to users' do
    describe 'GET #new' do
      it 'assigns a new user as @user' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new user in the database' do
          expect { POST :create, user: attributes_for(:user) }
            .to change(User, :count).by(1)
        end

        it 'assigns a new created user as @user' do
          post :create, user: attributes_for(:user)
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_persisted
        end

        it "redirects to the created user's show page" do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to user_path(assigns[:user])
        end
      end
      context 'with invaild attributes' do
        it "doesn't save the new user in the database" do
          expect { post :create, user: { email: nil } }
            .not_to change(User, :count)
        end

        it 're-renders the :new template' do
          post :create, user: { username: nil }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'user access' do
    before :each do
      user_session create(:user)
    end

    it_behaves_like 'public access to users'

    describe 'GET #edit' do
      it 'assigns the requested user as @user' do
        user = create(:user)
        get :edit, id: user

        expect(assigns(:user)).to eq user
      end

      it 'renders the :edit template' do
        user = create(:user)
        get :edit, id: user

        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      before :each do
        @user = create(:user, username: 'Nick Van Exel', email: 'n@ve.com')
      end

      context 'valid attributes' do
        it 'locates the requested user' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(assigns(:user)).to eq(@user)
        end

        it "updates @user's attributes" do
          patch :update, id: @user, user: attributes_for(:user,
                                                         username: 'Eddie Jones',
                                                         email: 'elevator@lakers.com')
          @user.reload
          expect(@user.username).to eq('Eddie Jones')
          expect(@user.email).to eq('elevator@lakers.com')
        end

        it 'redirects to updated user profile page' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(response).to redirect_to @user
        end
      end

      context 'with invalid attributes' do
        it "doesn't change the users' attributes" do
          patch :update, id: @user,
          user: attributes_for(:user,
                               username: nil,
                               email: 'invalidatNoG00demai7.com')
          @user.reload
          expect(@user.username).to eq('Nick Van Exel')
          expect(@user.email).to eq('n@ve.com')
        end

        it 're-renders the :edit template' do
          patch :update, id: @user, user: { email: nil }
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @user = create(:user)
      end

      it 'deletes the user' do
        expect { delete :destroy, id: @user }
          .to change(User, :count).by(-1)
      end

      it 'redirects to projects#index' do
        delete :destroy, id: @user
        expect(response).to redirect_to projects_url
      end
    end
  end

  describe 'public access' do
    it_behaves_like 'public access to users'

    describe 'GET #edit' do
      it 'requires user access' do
        get :edit, id: create(:user)
        expect(response).to redirect_to projects_url
      end
    end

    describe 'PATCH #update' do
      it 'requires user access' do
        patch :update, id: create(:user), user: attributes_for(:user)
        expect(response).to redirect_to projects_url
      end
    end

    describe 'DELETE #destroy' do
      it 'requires user access' do
        delete :destroy, id: create(:user)
        expect(response).to redirect_to projects_url
      end

      it "doesn't delete user" do
        expect { delete :destroy, id: create(:user) }
          .not_to change(User, :count)
      end
    end
  end
end
