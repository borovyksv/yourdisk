package com.relzet.service;

import com.relzet.dao.UserDocumentDao;
import com.relzet.model.UserDocument;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("userDocumentService")
@Transactional
public class UserDocumentServiceImpl implements UserDocumentService{

	@Autowired
	UserDocumentDao dao;

	public UserDocument findById(int id) {
		return dao.findById(id);
	}

	public List<UserDocument> findAll() {
		return dao.findAll();
	}

	public List<UserDocument> findAllByUserId(int userId) {
		return dao.findAllByUserId(userId);
	}
	
	public void saveDocument(UserDocument document){
		dao.save(document);
	}

	public void deleteFolderById(int id){
		dao.deleteFolderById(id);
	}

	@Override
	public void deleteById(int docId, int currentFolderId) {
		dao.deleteById(docId, currentFolderId);
	}

	public List<UserDocument> findAllInFolder(int userId, int docId) {
		return dao.findAllInFolder(userId, docId);
	}

	public UserDocument findRootByUserId(int userId) {
		return dao.findRootByUserId(userId);
	}

	@Override
	public List<UserDocument> findFoldersInFolder(int userId, int docId) {
		return dao.findFoldersInFolder(userId, docId);
	}

	@Override
	public List<UserDocument> findDocsInFolder(int userId, int docId) {
		return dao.findDocsInFolder(userId, docId);
	}

	@Override
	public List<UserDocument> searchFoldersInFolder(int userId, int docId, String target) {
		return dao.searchFoldersInFolder(userId, docId, target);
	}

	@Override
	public List<UserDocument> searchDocsInFolder(int userId, int docId, String target) {
		return dao.searchDocsInFolder(userId, docId, target);
	}


	@Override
	public List<UserDocument> filterDocsInFolder(int userId, int docId, String[] filters) {
		return dao.filterDocsInFolder(userId, docId, filters);

	}

	@Override
	public boolean checkFolderNameUnique(int userId, int docId, String folderName) {
		return dao.checkFolderNameUnique(userId, docId, folderName);
	}

	@Override
	public void updateDocument(UserDocument document) {
		dao.updateDoc(document);
	}


}
