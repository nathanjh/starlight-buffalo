require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  shared_examples 'public access to projects' do
    describe 'GET #index' do
      it 'responds successfully with an HTTP 200 status code' do
        get :index
        expect(response). to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end

      it 'collects all projects into @projects' do
        projects = Array.new(2) { create(:project) }
        get :index

        expect(assigns(:projects)).to eq projects
      end
    end

    describe 'GET #show' do
      it 'assigns the requested project as @project' do
        project = create(:project)
        get :show, id: project

        expect(assigns(:project)).to eq project
      end

      it 'renders the :show template' do
        project = create(:project)
        get :show, id: project

        expect(respose).to render_template :show
      end
    end
  end

  describe 'guest and user project access (all non admin)' do
    it_behaves_like 'public access to projects'

    describe 'GET #new' do
      it 'requires admin access' do
        get :new
        expect(response).to redirect_to projects_url
      end
    end

    describe 'GET #edit' do
      it 'requires admin access' do
        get :edit, id: create(:project)
        expect(response).to redirect_to projects_url
      end
    end

    describe 'POST #create' do
      it 'requires admin access' do
        post :create, id: create(:project), project: attributes_for(:project)
        expect(response).to redirect_to projects_url
      end
    end

    describe 'PATCH #update' do
      it 'requires admin access' do
        put :update, id: create(:project), project: attributes_for(:project)
        expect(response).to redirect_to projects_url
      end
    end

    describe 'DELETE #destroy' do
      it 'requires admin access' do
        delete :destroy, id: create(:project)
        expect(response).to redirect_to projects_url
      end
    end
  end

  describe 'admin access' do
    before :each do
      user_session create(:admin)
    end

    it_behaves_like 'public access to projects'

    describe 'GET #new' do
      it 'assigns a new project as @project' do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested project as @project' do
        project = create(:project)
        get :edit, id: project

        expect(assigns(:project)).to eq project
      end

      it 'renders the :edit template' do
        project = create(:project)
        get :edit, id: project

        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new project in the database' do
          expect { post :create, project: attributes_for(:project) }
            .to change(Project, :count).by(1)
        end

        it 'assigns a newly created project as @project' do
          post :create, project: attributes_for(:project)
          expect(assigns(:project)).to be_a(Project)
          expect(assigns(:project)).to be_persisted
        end

        it 'redirects to the created project' do
          post :create, project: attributes_for(:project)
          expect(response).to redirect_to project_path(assigns[:project])
        end
      end
      context 'with invaild attributes' do
        it "doesn't save the new project in the database" do
          expect { post :create, project: { title: nil } }
            .not_to change(Project, :count)
        end

        it 're-renders the :new template' do
          post :create, project: { title: nil }
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @project = create(:project,
                          title: 'Ant Farm Keyboard',
                          description: "It's an ant-farm-keyboard!")
      end

      context 'valid attributes' do
        it 'locates the requested project' do
          patch :update, id: @project, project: attributes_for(:project)
          expect(assigns(:project)).to eq(@project)
        end

        it "updates @project's attributes" do
          patch :update, id: @project,
          project: attributes_for(:project,
                                  title: "A fool's fortress",
                                  description: "I like to call it 'lost wages!'")
          @project.reload
          expect(@project.title).to eq("A fool's fortress")
          expect(@project.description).to eq("I like to call it 'lost wages!'")
        end

        it 'redirects to the updated project' do
          patch :update, id: @project, project: attributes_for(:project)
          expect(response).to redirect_to @project
        end
      end

      context 'with invaild attributes' do
        it "doesn't change the projects' attributes" do
          patch :update, id: @project,
          project: attributes_for(:project,
                                  title: nil,
                                  description: "I like to call it 'lost wages!'")
          @project.reload
          expect(@project.title).not_to eq("A fool's fortress")
          expect(@project.description).not_to eq("I like to call it 'lost wages!'")
        end

        it 're-renders the :edit template' do
          patch :update, id: @project, project: { title: nil }
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @project = create(:project)
      end

      it 'deletes the project' do
        expect { delete :destroy, id: @project }
          .to change(Project, :count).by(-1)
      end

      it 'redirects to projects#index' do
        delete :destroy, id: @project
        expect(response).to redirect_to projects_url
      end
    end
  end
end
