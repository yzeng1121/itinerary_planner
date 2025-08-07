//
//  CreateTripViewController.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//
import UIKit

protocol CreateTripDelegate: AnyObject {
    func didCreateTrip(_ trip: Trip)
}

class CreateTripViewController: UIViewController {
    
    weak var delegate: CreateTripDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleTextField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title section
        let titleContainer = createSectionContainer()
        let titleLabel = createSectionLabel(text: "Trip Name")
        
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Enter trip name"
        titleTextField.font = UIFont.systemFont(ofSize: 16)
        
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(titleTextField)
        
        // Start date section
        let startDateContainer = createSectionContainer()
        let startDateLabel = createSectionLabel(text: "Start Date")
        
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        
        startDateContainer.addSubview(startDateLabel)
        startDateContainer.addSubview(startDatePicker)
        
        // End date section
        let endDateContainer = createSectionContainer()
        let endDateLabel = createSectionLabel(text: "End Date")
        
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        endDateContainer.addSubview(endDateLabel)
        endDateContainer.addSubview(endDatePicker)
        
        contentView.addSubview(titleContainer)
        contentView.addSubview(startDateContainer)
        contentView.addSubview(endDateContainer)
        
        // Layout
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            titleTextField.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            startDateContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 20),
            startDateContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startDateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            startDateLabel.topAnchor.constraint(equalTo: startDateContainer.topAnchor, constant: 16),
            startDateLabel.leadingAnchor.constraint(equalTo: startDateContainer.leadingAnchor, constant: 16),
            startDateLabel.trailingAnchor.constraint(equalTo: startDateContainer.trailingAnchor, constant: -16),
            
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 8),
            startDatePicker.leadingAnchor.constraint(equalTo: startDateContainer.leadingAnchor, constant: 16),
            startDatePicker.trailingAnchor.constraint(equalTo: startDateContainer.trailingAnchor, constant: -16),
            startDatePicker.bottomAnchor.constraint(equalTo: startDateContainer.bottomAnchor, constant: -16),
            
            endDateContainer.topAnchor.constraint(equalTo: startDateContainer.bottomAnchor, constant: 20),
            endDateContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            endDateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            endDateContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            endDateLabel.topAnchor.constraint(equalTo: endDateContainer.topAnchor, constant: 16),
            endDateLabel.leadingAnchor.constraint(equalTo: endDateContainer.leadingAnchor, constant: 16),
            endDateLabel.trailingAnchor.constraint(equalTo: endDateContainer.trailingAnchor, constant: -16),
            
            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 8),
            endDatePicker.leadingAnchor.constraint(equalTo: endDateContainer.leadingAnchor, constant: 16),
            endDatePicker.trailingAnchor.constraint(equalTo: endDateContainer.trailingAnchor, constant: -16),
            endDatePicker.bottomAnchor.constraint(equalTo: endDateContainer.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupNavigationBar() {
        title = "New Trip"
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func createSectionContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 0.1
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    private func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }
    
    @objc private func startDateChanged() {
        if startDatePicker.date >= endDatePicker.date {
            endDatePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: startDatePicker.date) ?? startDatePicker.date
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter a trip name")
            return
        }
        
        guard startDatePicker.date <= endDatePicker.date else {
            showAlert(message: "Start date must be before end date")
            return
        }
        
        let trip = Trip(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: startDatePicker.date,
            endDate: endDatePicker.date
        )
        
        delegate?.didCreateTrip(trip)
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
