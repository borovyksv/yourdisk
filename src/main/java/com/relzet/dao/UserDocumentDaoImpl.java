package com.relzet.dao;

import com.relzet.model.UserDocument;
import org.hibernate.Criteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.*;

@SuppressWarnings("unchecked")
@Repository("userDocumentDao")
public class UserDocumentDaoImpl extends AbstractDao<Integer, UserDocument> implements UserDocumentDao{

	public List<UserDocument> findAll() {
		Criteria crit = createEntityCriteria();
		return (List<UserDocument>)crit.list();
	}

	public void save(UserDocument document) {
		persist(document);
	}

	public void updateDoc(UserDocument document) {
		update(document);
	}

	public UserDocument findById(int id) {
		return getByKey(id);
	}

	public List<UserDocument> findAllByUserId(int userId){
		Criteria crit = createEntityCriteria();
		Criteria userCriteria = crit.createCriteria("user");
		userCriteria.add(Restrictions.eq("id", userId));
		return (List<UserDocument>)crit.list();
	}

	public List<UserDocument> findAllInFolder(int userId, int folderId) {

		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", folderId));
		return (List<UserDocument>)crit.list();

	}

	public void deleteFolderById(int id) {
		UserDocument document =  getByKey(id);
			for(UserDocument doc : findAllInFolder(document.getUser().getId(), id)){
				if (doc.isFolder()) deleteFolderById(doc.getId());
				else delete(doc);
			}
		delete(document);
	}

	@Override
	public void deleteById(int docId, int currentFolderId) {
			UserDocument document = findById(docId);
			UserDocument folder = findById(currentFolderId);

			folder.setSize(folder.getSize()-document.getSize());
			folder.setFilesCounter(folder.getFilesCounter()-1);

			updateDoc(folder);
			delete(document);

	}
	public Criteria getCriteriaByUserId(int userId) {
		Criteria crit = createEntityCriteria();
		Criteria userCriteria = crit.createCriteria("user");
		userCriteria.add(Restrictions.eq("id", userId));
		return crit;
	}


	public UserDocument findRootByUserId(int userId) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", 0));
		return (UserDocument) crit.uniqueResult();
	}

	@Override
	public List<UserDocument> findFoldersInFolder(int userId, int folderId) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", folderId));
		crit.add(Restrictions.eq("type", "folder"));
		return (List<UserDocument>)crit.list();
	}

	@Override
	public List<UserDocument> findDocsInFolder(int userId, int folderId) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", folderId));
		crit.add(Restrictions.ne("type", "folder"));
		return (List<UserDocument>)crit.list();
	}

	@Override
	public List<UserDocument> searchFoldersInFolder(int userId, int folderId, String target) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", folderId));
		crit.add(Restrictions.eq("type", "folder"));
		crit.add(Restrictions.ilike("name", target, MatchMode.ANYWHERE));
		return (List<UserDocument>)crit.list();

//		List<UserDocument> result = new ArrayList<>();
//
//		for(UserDocument ud: findAllInFolder(userId, docId)) {
//			if (ud.getType().equals("folder")&&ud.getName().contains(target)) result.add(ud);
//		}
//
//		return result;
	}

	@Override
	public List<UserDocument> searchDocsInFolder(int userId, int folderId, String target) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("parentFolderId", folderId));
		crit.add(Restrictions.ne("type", "folder"));
		crit.add(Restrictions.ilike("name", target, MatchMode.ANYWHERE));
		return (List<UserDocument>)crit.list();

//		List<UserDocument> result = new ArrayList<UserDocument>();
//
//		for(UserDocument ud: findAllInFolder(userId, docId)) {
//			if ((!ud.getType().equals("folder"))&&ud.getName().contains(target)) result.add(ud);
//		}
//
//		return result;
	}

	@Override
	public List<UserDocument> filterDocsInFolder(int userId, int docId, String[] filters) {
		List<UserDocument> result = new ArrayList<>();
		List<String> formats = new ArrayList<>();

		//here you can change filter formats
		for (String filter : filters) {
			switch (filter) {
				case "documents": formats.addAll(new ArrayList<>(Arrays.asList("text", "plain", "pdf", "officedocument", "msword"))); break;
				case "pictures": formats.addAll(new ArrayList<>(Arrays.asList("image")));break;
				case "videos": formats.addAll(new ArrayList<>(Arrays.asList("video")));break;
				case "zip": formats.addAll(new ArrayList<>(Arrays.asList("zip")));break;
			}
		}

		for(UserDocument ud: findAllByUserId(userId)) {
			for (String format : formats)
			if (ud.getType().contains(format)) result.add(ud);
		}
		return result;
	}

	@Override
	public boolean checkFolderNameUnique(int userId, int docId, String folderName) {
		for (UserDocument ud : findFoldersInFolder(userId, docId)) {
			if (ud.getName().equals(folderName)) return true;
		}
		return false;
	}

	@Override
	public List<UserDocument> getTopFiles(int userId) {
		Criteria crit = getCriteriaByUserId(userId);
		crit.add(Restrictions.eq("folder", false));
		crit.addOrder(Order.desc("size"));
		crit.setMaxResults(5);
		return (List<UserDocument>)crit.list();

	}
}
