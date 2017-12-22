describe NotePolicy do
  subject { NotePolicy }

  let (:current_user) { FactoryGirl.build_stubbed :user }
  let (:admin) { FactoryGirl.build_stubbed :user, :admin }
  let (:moderator) { FactoryGirl.build_stubbed :user, :moderator }

  let :viewer do
    User.create(name: 'sexylexywenttonexy', email: 'test@example.com', password: 'please123')
  end

  let :note do
    Note.create(content: 'content').tap do |n|
      n.visible_to = 'sexylexywenttonexy'
      n.user = User.create(name: 'iamzeeothoor', email: 'test@example.com', password: 'pleaseworkforme123')
    end
  end

  permissions :index? do
    it 'denies access if not a moderator' do
      expect(NotePolicy).not_to permit(current_user)
    end

    it 'allows access if a moderator' do
      expect(NotePolicy).to permit(moderator)
    end

    it 'allows access if an admin' do
      expect(NotePolicy).to permit(admin)
    end
  end

  permissions :show? do 
    it 'denies access if not a moderator, not a viewer and not an author' do
      expect(NotePolicy).not_to permit(current_user, note)
    end

    it 'allows access if a moderator' do
      expect(NotePolicy).to permit(moderator, note)
    end

    it 'allows access if an admin' do
      expect(NotePolicy).to permit(admin, note)
    end

    it 'allows access if a viewer' do
      expect(NotePolicy).to permit(viewer, note)
    end

    it 'allows access if an author' do
      expect(NotePolicy).to permit(note.user, note)
    end
  end

  permissions :edit? do
    it 'denies access to anyone that is not an admin or owner' do
      expect(NotePolicy).not_to permit(current_user, note)
    end

    it 'allows admin to edit note' do
      expect(NotePolicy).to permit(admin)
    end

    it 'allows users to edit their own notes' do
      expect(NotePolicy).to permit(note.user, note)
    end
  end

  permissions :destroy? do
    it 'denies access to anyone that is not an admin or owner' do
      expect(NotePolicy).not_to permit(current_user, note)
    end

    it 'allows admin to edit note' do
      expect(NotePolicy).to permit(admin)
    end

    it 'allows users to edit their own notes' do
      expect(NotePolicy).to permit(note.user, note)
    end
  end
end 