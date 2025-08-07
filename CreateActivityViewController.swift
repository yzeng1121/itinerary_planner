//
//  CreateActivityViewController.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//
import UIKit

protocol CreateActivityDelegate: AnyObject {
    func didCreateActivity()
    func didUpdateActivity()
}

class CreateActivityViewController: UIViewController {
    
    weak var delegate: CreateActivityDelegate?
    
    private let tripId: UUID
    private let existingActivity: Activity?
    private let activityIndex: Int?
    private let tripManager = TripManager.shared
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleTextField = UITextField()
    private let locationTextField = UITextField()
    private let durationTextField = UITextField()
    private let timePicker = UIDatePicker()
    private let typeSegmentedControl = UISegmentedControl(items: ActivityType.allCases.map { $0.rawValue.capitalized })
    
    init(tripId: UUID, activity: Activity? = nil, activityIndex: Int? = nil) {
        self.tripId = tripId
        self.existingActivity = activity
        self.activityIndex = activityIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        populateFields()
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
        let titleLabel = createSectionLabel(text: "Activity Title")
        
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Enter activity title"
        titleTextField.font = UIFont.systemFont(ofSize: 16)
        
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(titleTextField)
        
        // Location section
        let locationContainer = createSectionContainer()
        let locationLabel = createSectionLabel(text: "Location")
        
        locationTextField.borderStyle = .roundedRect
        locationTextField.placeholder = "Enter location"
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        
        locationContainer.addSubview(locationLabel)
        locationContainer.addSubview(locationTextField)
        
        // Time section
        let timeContainer = createSectionContainer()
        let timeLabel = createSectionLabel(text: "Time")
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        timeContainer.addSubview(timeLabel)
        timeContainer.addSubview(timePicker)
        
        // Type section
        let typeContainer = createSectionContainer()
        let typeLabel = createSectionLabel(text: "Activity Type")
        
        typeSegmentedControl.selectedSegmentIndex = 0
        
        typeContainer.addSubview(typeLabel)
        typeContainer.addSubview(typeSegmentedControl)
        
        // Duration section
        let durationContainer = createSectionContainer()
        let durationLabel = createSectionLabel(text: "Duration (Optional)")
        
        durationTextField.borderStyle = .roundedRect
        durationTextField.placeholder = "e.g., 2 hours"
        durationTextField.font = UIFont.systemFont(ofSize: 16)
        
        durationContainer.addSubview(durationLabel)
        durationContainer.addSubview(durationTextField)
        
        contentView.addSubview(titleContainer)
        contentView.addSubview(locationContainer)
        contentView.addSubview(timeContainer)
        contentView.addSubview(typeContainer)
        contentView.addSubview(durationContainer)
        
        // Layout
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        durationTextField.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            locationContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 20),
            locationContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: locationContainer.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor, constant: -16),
            
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationTextField.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor, constant: 16),
            locationTextField.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor, constant: -16),
            locationTextField.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: -16),
            locationTextField.heightAnchor.constraint(equalToConstant: 44),
            
            timeContainer.topAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: 20),
            timeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: timeContainer.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: timeContainer.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: timeContainer.trailingAnchor, constant: -16),
            
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            timePicker.leadingAnchor.constraint(equalTo: timeContainer.leadingAnchor, constant: 16),
            timePicker.trailingAnchor.constraint(equalTo: timeContainer.trailingAnchor, constant: -16),
            timePicker.bottomAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: -16),
            
            typeContainer.topAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: 20),
            typeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            typeLabel.topAnchor.constraint(equalTo: typeContainer.topAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: typeContainer.leadingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: typeContainer.trailingAnchor, constant: -16),
            
            typeSegmentedControl.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: typeContainer.leadingAnchor, constant: 16),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: typeContainer.trailingAnchor, constant: -16),
            typeSegmentedControl.bottomAnchor.constraint(equalTo: typeContainer.bottomAnchor, constant: -16),
            typeSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            durationContainer.topAnchor.constraint(equalTo: typeContainer.bottomAnchor, constant: 20),
            durationContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            durationContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            durationContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            durationLabel.topAnchor.constraint(equalTo: durationContainer.topAnchor, constant: 16),
            durationLabel.leadingAnchor.constraint(equalTo: durationContainer.leadingAnchor, constant: 16),
            durationLabel.trailingAnchor.constraint(equalTo: durationContainer.trailingAnchor, constant: -16),
            
            durationTextField.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            durationTextField.leadingAnchor.constraint(equalTo: durationContainer.leadingAnchor, constant: 16),
            durationTextField.trailingAnchor.constraint(equalTo: durationContainer.trailingAnchor, constant: -16),
            durationTextField.bottomAnchor.constraint(equalTo: durationContainer.bottomAnchor, constant: -16),
            durationTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNavigationBar() {
        title = existingActivity != nil ? "Edit Activity" : "New Activity"
        
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
    
    private func populateFields() {
        guard let activity = existingActivity else { return }
        
        titleTextField.text = activity.title
        locationTextField.text = activity.location
        timePicker.date = activity.time
        durationTextField.text = activity.duration
        
        if let typeIndex = ActivityType.allCases.firstIndex(of: activity.type) {
            typeSegmentedControl.selectedSegmentIndex = typeIndex
        }
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
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter an activity title")
            return
        }
        
        guard let location = locationTextField.text, !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter a location")
            return
        }
        
        let selectedTypeIndex = typeSegmentedControl.selectedSegmentIndex
        let activityType = ActivityType.allCases[selectedTypeIndex]
        
        let duration = durationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDuration = duration?.isEmpty == false ? duration : nil
        
        let activity = Activity(
            time: timePicker.date,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            type: activityType,
            duration: finalDuration
        )
        
        if let existingActivity = existingActivity, let activityIndex = activityIndex {
            // Update existing activity
            tripManager.updateActivity(in: tripId, at: activityIndex, with: activity)
            delegate?.didUpdateActivity()
        } else {
            // Create new activity
            tripManager.addActivity(to: tripId, activity: activity)
            delegate?.didCreateActivity()
        }
        
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
